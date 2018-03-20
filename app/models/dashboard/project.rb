# frozen_string_literal: true
module Dashboard
  class Project < ApplicationRecord
    include AsanaApi

    COCOBURG_WORKSPACE_ID = ENV['ASANA_WORKSPACE_ID'].to_i.freeze

    has_many :tasks, -> { extending TasksAssociationExtension },
             dependent: :delete_all,
             foreign_key: 'dashboard_project_id'
    PROJECT_OPTIONS = {
      fields: %w(color
                 due_date
                 modified_at
                 name
                 notes
                 archived
                 current_status).freeze
    }.freeze

    def task_list_url
      "https://app.asana.com/0/#{project_id}/list"
    end

    def status_update_url
      "https://app.asana.com/0/#{project_id}/progress"
    end

    def display?
      display_in_dashboard && !archived
    end

    scope :displayable, -> { where(display_in_dashboard: true, archived: false) }

    def save_project_status
      api_client.put("/projects/#{project_id}", body: status_representation, options: {})
    end

    def status_representation
      {
        current_status: {
          color: status_color,
          text: current_status
        }
      }
    end

    def status_changed?
      current_status_changed? || status_color_changed?
    end

    def asana_project
      @asana_project ||= Asana::Project.find_by_id(api_client, project_id.to_i)
    end

    class << self
      def reload_all
        client = api_client
        workspace = client.workspaces.find_by_id(COCOBURG_WORKSPACE_ID)

        Asana::Resources::Project.find_all(client,
                                           workspace: workspace.id,
                                           options: PROJECT_OPTIONS).each do |asana_project|
          puts asana_project.name
          new_project = create_from_asana(asana_project)
          puts '   tasks'
          new_project.tasks.reload! if new_project.display?
        end
      end

      def find_user_name_by_id(id)
        @users ||= {}
        @users[id] ||= Asana::Resources::User.find_by_id(api_client, id)
        @users[id].name
      end

      private

      def create_from_asana(asana_project)
        dashboard_project = find_or_initialize_by(project_id: asana_project.id.to_s)
        dashboard_project.attributes = {
          color: asana_project.color,
          due_date: asana_project.due_date,
          project_modified_at: asana_project.modified_at,
          name: asana_project.name,
          notes: asana_project.notes,
          archived: asana_project.archived
        }
        dashboard_project.attributes = get_status_attributes(asana_project.current_status)
        dashboard_project.save!
        dashboard_project
      end

      def api_client
        Asana::Client.new do |c|
          c.authentication :access_token, ENV['ASANA_ACCESS_TOKEN']
        end
      end

      def get_status_attributes(status_object)
        return {} unless status_object
        {
          status_updated_at: status_object['modified_at'],
          status_updated_by: find_user_name_by_id(status_object['author']['id']),
          status_color: status_object['color'],
          current_status: status_object['text']
        }
      end
    end
  end
end
