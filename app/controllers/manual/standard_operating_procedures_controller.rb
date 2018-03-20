# frozen_string_literal: true
module Manual
  class StandardOperatingProceduresController < ApplicationController
    before_action :set_manual_standard_operating_procedure, except: [:index, :new, :create]

    respond_to :html, :js, :json

    def index
      @sops = Manual::StandardOperatingProcedure.order(process_id: :asc)
      respond_with(@sops) do |format|
        format.zip do
          send_data send_zip_file, filename: 'Manufacturing Standard Operating Procedures.zip'
        end
      end
    end

    def send_zip_file
      Zip::OutputStream.write_buffer  do |out|
        [StandardOperatingProcedure, ProcessFlow].each do |klass|
          klass.all.each do |model|
            out.put_next_entry filename(model)
            out.write model.to_pdf
          end
        end
      end.string
    end

    def filename(model)
      dir_name = model.class.name.demodulize.underscore.tableize.titleize
      File.join(dir_name, model.output_filename)
    end

    def show
      respond_with(@standard_operating_procedure) do |format|
        format.pdf do
          send_data @standard_operating_procedure.to_pdf(encrypt: true),
                    filename: @standard_operating_procedure.filename,
                    type: 'application/pdf',
                    disposition: 'inline'
        end
      end
    end

    def new
      @standard_operating_procedure = Manual::StandardOperatingProcedure.new
      respond_with(@standard_operating_procedure)
    end

    def edit
      @change_log = @standard_operating_procedure.change_logs.build(user: current_user)
    end

    def history
      @document = @standard_operating_procedure
    end

    def create
      @operating_procedure = StandardOperatingProcedure.new(sop_params)
      @operating_procedure.author = current_user

      @operating_procedure.save
      respond_with(@operating_procedure)
    end

    def update
      if request.format == :js || request.format == :json
        body = ActiveSupport::JSON.decode(sop_params[:body])
        @standard_operating_procedure.update body: body
      else
        @standard_operating_procedure.update(sop_params)
      end
      respond_with(@standard_operating_procedure)
    end

    def destroy
      @standard_operating_procedure.destroy
      respond_with(@standard_operating_procedure)
    end

    private

    def set_manual_standard_operating_procedure
      @standard_operating_procedure = StandardOperatingProcedure.friendly.find(params[:id])
    end

    ALLOWED_PARAMS = [{
      change_logs_attributes: [:notes, :user_id]
    },
                      :title,
                      :version,
                      :document_id,
                      :process_id,
                      :author_id,
                      :workflow_state,
                      :body].freeze

    def sop_params
      params.require(:manual_standard_operating_procedure).permit(*ALLOWED_PARAMS)
    end
  end
end
