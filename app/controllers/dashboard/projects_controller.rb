# frozen_string_literal: true
module Dashboard
  class ProjectsController < ApplicationController
    respond_to :html, :json, :js

    def index
      @dashboard_projects = Dashboard::Project.displayable
                                              .order(status_updated_at: :desc)
      return unless stale? @dashboard_projects
    end

    def update
      @dashboard_project = Dashboard::Project.find(params[:id])
      authorize! :update, @dashboard_project
      @dashboard_project.attributes = dashboard_project_params
      if @dashboard_project.status_changed?
        @dashboard_project.save_project_status
        @dashboard_project.status_updated_at = DateTime.now
      end
      @dashboard_project.save
      respond_with(@dashboard_project) do |format|
        format.json do
          render json: @dashboard_project
        end
      end
    end

    def destroy
      @dashboard_project = Dashboard::Project.find(params[:id])
      authorize! :update, @dashboard_project
      @dashboard_project.update display_in_dashboard: false
      respond_with(@dashboard_project)
    end

    private

    def set_dashboard_project
      @dashboard_project = Dashboard::Project.find(params[:id])
    end

    PROJECT_PARAMS = [:name,
                      :project_modified_at,
                      :status_updated_at,
                      :status_updated_by,
                      :status_color,
                      :name,
                      :due_date,
                      :project_id,
                      :current_status,
                      :color,
                      :notes,
                      :archived,
                      :display_in_dashboard].freeze

    def dashboard_project_params
      params.require(:dashboard_project).permit(PROJECT_PARAMS)
    end
  end
end
