require "test_helper"

class InvitationMailerTest < ActionMailer::TestCase
  test "invite_email" do
    invitation = invitations(:one)

    mail = InvitationMailer.invite_email(invitation)

    assert_equal I18n.t(
      "invitation_mailer.invite_email.subject",
      inviter: invitation.inviter.display_name,
      product_name: Rails.configuration.x.product_name
    ), mail.subject
    assert_equal [ invitation.email ], mail.to
    assert_equal [ "hello@example.com" ], mail.from
    assert_match "accept", mail.body.encoded
  end

  test "uses the invited family's Czech locale" do
    invitation = invitations(:one)
    invitation.family.update_column(:locale, "cs")

    mail = InvitationMailer.invite_email(invitation)

    assert_equal I18n.t(
      "invitation_mailer.invite_email.subject",
      locale: :cs,
      inviter: invitation.inviter.display_name,
      product_name: Rails.configuration.x.product_name
    ), mail.subject
  end
end
