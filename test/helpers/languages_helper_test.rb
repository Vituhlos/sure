require "test_helper"

class LanguagesHelperTest < ActionView::TestCase
  test "#language_options exposes Czech under its native name" do
    assert_includes language_options, [ "Čeština (cs)", :cs ]
    assert_includes language_options, [ "Deutsch (de)", :de ]
    assert_includes language_options, [ "Español (es)", :es ]
    assert_includes language_options, [ "Français (fr)", :fr ]
  end

  test "#timezone_options uses Czech names and keeps the IANA identifier visible" do
    I18n.with_locale(:cs) do
      label, value = timezone_options.find { |_label, identifier| identifier == "Europe/Prague" }

      assert_equal "Europe/Prague", value
      assert_includes label, "Středoevropský čas"
      assert_includes label, "Europe/Prague"
    end
  end
end
