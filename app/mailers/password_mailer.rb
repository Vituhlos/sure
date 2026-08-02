class PasswordMailer < ApplicationMailer
  def password_reset
    @user = params[:user]

    I18n.with_locale(locale_for(@user)) do
      @subject = t(".subject", product_name: product_name)
      @cta = t(".cta")

      mail to: @user.email, subject: @subject
    end
  end
end
