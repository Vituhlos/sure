class PdfImportMailer < ApplicationMailer
  def next_steps
    @user = params[:user]
    @pdf_import = params[:pdf_import]
    @import_url = import_url(@pdf_import)
    locale = @user.locale.presence || @user.family.locale.presence || I18n.default_locale

    I18n.with_locale(locale) do
      mail(
        to: @user.email,
        subject: t(".subject", product_name: product_name)
      )
    end
  end
end
