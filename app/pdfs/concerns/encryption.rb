# frozen_string_literal: true
module Encryption
  def initialize(root, options)
    @do_encrypt = if options.key?(:encrypt)
                    options.delete(:encrypt)
                  else
                    true
                  end
    super(root, options)
  end

  def finish_document(_)
    super
    encrypt if @do_encrypt
  end

  private

  def encrypt(pdf = @pdf)
    pdf.encrypt_document encryption_settings
  end

  def encryption_settings
    settings = {
      owner_password: PDF_OWNER_PASSWORD,
      permissions: {
        print_document: false,
        modify_contents: false,
        copy_contents: false,
        modify_annotations: false
      }
    }
    settings[:user_password] = PDF_USER_PASSWORD if Rails.env.production?
    settings
  end
  PDF_OWNER_PASSWORD = ENV.fetch('PDF_OWNER_PASSWORD') { 'ijustdid' }
  PDF_USER_PASSWORD  = ENV.fetch('PDF_USER_PASSWORD') { 'rise' }
end
