require "test_helper"

class PasswordMailerTest < ActionMailer::TestCase
  test "uses the recipient's Czech locale" do
    user = users(:family_admin)
    user.update_column(:locale, "cs")

    mail = PasswordMailer.with(user: user).password_reset

    assert_equal I18n.t(
      "password_mailer.password_reset.subject",
      locale: :cs,
      product_name: Rails.configuration.x.product_name
    ), mail.subject
  end
end
