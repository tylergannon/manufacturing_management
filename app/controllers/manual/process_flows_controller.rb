# frozen_string_literal: true
module Manual
  class ProcessFlowsController < ApplicationController
    before_action :set_manual_process_flow, except: [:index, :new, :create]

    respond_to :html

    def index
      @manual_process_flows = Manual::ProcessFlow.order(process_id: :asc)
      respond_with(@manual_process_flows)
    end

    def show
      if params[:process_flow_body]
        @manual_process_flow.body = params[:process_flow_body]
      end
      unless @manual_process_flow.valid?
        puts @manual_process_flow.errors.inspect
      end
      respond_with(@manual_process_flow) do |format|
        format.pdf { send_pdf(@manual_process_flow) }
        format.png { send_png(@manual_process_flow) }
      end
    end

    def new
      @manual_process_flow = Manual::ProcessFlow.new
      respond_with(@manual_process_flow)
    end

    def edit
      @change_log = @manual_process_flow.change_logs.build(user: current_user)
    end

    def create
      @manual_process_flow = Manual::ProcessFlow.new(process_flow_params)
      @manual_process_flow.author = current_user
      @manual_process_flow.save
      respond_with(@manual_process_flow)
    end

    def history
      @document = @manual_process_flow
    end

    def json_attributes
      {
        body: ActiveSupport::JSON.decode(process_flow_params[:body]),
        aspect_ratio: process_flow_params[:aspect_ratio],
        layout: process_flow_params[:layout]
      }
    end

    def update
      if request.format == :js || request.format == :json
        @manual_process_flow.update json_attributes
      else
        @manual_process_flow.update(process_flow_params)
      end

      respond_with(@manual_process_flow)
    end

    def destroy
      @manual_process_flow.destroy
      respond_with(@manual_process_flow)
    end

    private

    def send_pdf(process_flow)
      send_data process_flow.to_pdf,
                filename: "#{@manual_process_flow.title}.pdf",
                type: 'application/pdf',
                disposition: 'inline'
    end

    def send_png(process_flow)
      send_data process_flow.to_png,
                filename: "#{@manual_process_flow.title}.png",
                type: 'image/png',
                disposition: 'inline'
    end

    def set_manual_process_flow
      @manual_process_flow = Manual::ProcessFlow.friendly.find(params[:id])
    end

    ALLOWED_PARAMS = [{
      change_logs_attributes: [:notes, :user_id]
    },
                      :title,
                      :version,
                      :document_id,
                      :process_id,
                      :author_id,
                      :category,
                      :product,
                      :layout,
                      :aspect_ratio,
                      :body].freeze

    def process_flow_params
      params.require(:manual_process_flow).permit(*ALLOWED_PARAMS)
    end
  end
end
