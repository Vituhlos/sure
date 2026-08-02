require "test_helper"

class DemoFamilyRefreshMailerTest < ActionMailer::TestCase
  test "completed email includes summary metrics" do
    period_start = Time.utc(2026, 1, 1, 5, 0, 0)
    period_end = period_start + 24.hours

    email = DemoFamilyRefreshMailer.with(
      super_admin: users(:sure_support_staff),
      old_family_id: families(:empty).id,
      old_family_name: families(:empty).name,
      old_family_session_count: 12,
      newly_created_families_count: 4,
      period_start:,
      period_end:
    ).completed

    assert_equal [ "support@sure.am" ], email.to
    assert_equal "Demo family refresh completed", email.subject
    assert_includes email.body.to_s, "Unique login sessions for old demo family in period: 12"
    assert_includes email.body.to_s, "New family accounts created in period: 4"
  end

  test "uses the super admin's Czech locale" do
    super_admin = users(:sure_support_staff)
    super_admin.update_column(:locale, "cs")

    email = DemoFamilyRefreshMailer.with(
      super_admin:,
      old_family_id: nil,
      old_family_name: nil,
      old_family_session_count: 1,
      newly_created_families_count: 1,
      period_start: Time.utc(2026, 1, 1),
      period_end: Time.utc(2026, 1, 2)
    ).completed

    assert_equal "Obnovení ukázkové domácnosti bylo dokončeno", email.subject
  end
end
