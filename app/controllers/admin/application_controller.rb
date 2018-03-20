# frozen_string_literal: true
module Admin
  # All Administrate controllers inherit from `Admin::ApplicationController`,
  # making it the ideal place to put authentication logic or other
  # before_filters.
  #
  # If you want to add pagination or other controller-level concerns,
  # you're free to overwrite the RESTful controller actions.
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin
    before_action :default_params
    helper :application

    etag { latest_deployment }
    etag { flash unless flash.empty? }

    def index
      resources = load_resources
      # return unless stale? etag:
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: load_page
      }
    end

    def search_term
      params[:search].to_s.strip
    end

    def load_resources
      Administrate::Search.new(resource_resolver, search_term).run
    end

    def load_page
      Administrate::Page::Collection.new(dashboard, order: order)
    end

    def show
      return unless stale? requested_resource
      render locals: {
        page: Administrate::Page::Show.new(dashboard, requested_resource)
      }
    end

    def update
      if requested_resource.update(resource_params)
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource('update.success')
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource)
        }
      end
    end

    def edit
      return unless stale? requested_resource

      render locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource)
      }
    end

    def latest_deployment
      if Rails.env.production? || ENV['ETAGS']
        Deployment.latest_deployment || MIN_DEPLOYMENT_TIME
      else
        DateTime.now
      end
    end

    def authenticate_admin
      authenticate_user!
      raise "You can't be here." unless admin_signed_in?
    end

    def admin_signed_in?
      current_user.admin? || current_user.admin
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    private

    def default_params
      params[:order] ||= 'created_at'
      params[:direction] ||= 'desc'
    end
  end
end
