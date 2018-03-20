# frozen_string_literal: true
module Dashboard
  class TasksController < ApplicationController
    before_action :set_dashboard_task, only: [:show, :edit, :update, :destroy, :complete]

    respond_to :html

    def index
      @dashboard_tasks = Dashboard::Task.all
      respond_with(@dashboard_tasks)
    end

    def show
      respond_with(@dashboard_task)
    end

    def new
      @dashboard_task = Dashboard::Task.new
      respond_with(@dashboard_task)
    end

    def edit
    end

    def complete
      authorize! :update, @dashboard_task
      @dashboard_project = @dashboard_task.project
      @dashboard_task.complete!
      respond_with @dashboard_task
    end

    def create
      @dashboard_task = Dashboard::Task.new(dashboard_task_params)
      @dashboard_task.save
      respond_with(@dashboard_task)
    end

    def update
      @dashboard_task.update(dashboard_task_params)
      respond_with(@dashboard_task)
    end

    def destroy
      @dashboard_task.destroy
      respond_with(@dashboard_task)
    end

    private

    def set_dashboard_task
      @dashboard_task = Dashboard::Task.find(params[:id])
    end

    DASHBOARD_TASK_PARAMS = [:assignee,
                             :completed,
                             :completed_at,
                             :task_created_at,
                             :due_at,
                             :due_on,
                             :task_id,
                             :name,
                             :notes,
                             :task_modified_at,
                             :project_id].freeze

    def dashboard_task_params
      params.require(:dashboard_task).permit(DASHBOARD_TASK_PARAMS)
    end
  end
end
