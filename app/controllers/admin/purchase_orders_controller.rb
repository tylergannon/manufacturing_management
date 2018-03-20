# frozen_string_literal: true
module Admin
  class PurchaseOrdersController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = PurchaseOrder.order(po_number: :asc).page(params[:page])
    # end

    def event
      purchase_order = find_resource(params[:id])
      purchase_order.transition! params[:event]
      redirect_to admin_purchase_order_path(purchase_order)
    end

    def download_purchase_order
      purchase_order = find_resource(params[:id])
      redirect_to purchase_order.manufacturing_purchase_order.expiring_url(2)
    end

    helper_method :event_link_args

    def event_link_args(event)
      {
        method: :post,
        class: 'button',
        data: {
          confirm: "Really #{event.title} the PO?",
          turbolinks: 'false',
          'event-id' => event.name
        }
      }
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   PurchaseOrder.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
    private

    def default_params
      params[:order] ||= 'po_number'
      params[:direction] ||= 'desc'
    end
  end
end
