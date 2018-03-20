# frozen_string_literal: true
module Admin
  class UsersController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = User.all.paginate(10, params[:page])
    # end
    def create
      resource = create_user

      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource('create.success')
        )
      else
        render :new, locals: { page: new_page_resource }
      end
    end

    def new_page_resource(resource)
      Administrate::Page::Form.new(dashboard, resource)
    end

    def create_user
      resource = resource_class.new(resource_params)
      resource.password = SecureRandom.uuid
      resource
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   User.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
