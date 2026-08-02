require "test_helper"
require "bigdecimal"
require "securerandom"

class CzechPluralizationTest < ActiveSupport::TestCase
  test "uses all four Czech plural forms" do
    translation_key = "test_pluralization_#{SecureRandom.hex(6)}"

    I18n.backend.store_translations(:cs, translation_key => {
      sample: {
        one: "one",
        few: "few",
        many: "many",
        other: "other"
      }
    })

    path = "#{translation_key}.sample"

    {
      0 => "other",
      1 => "one",
      2 => "few",
      3 => "few",
      4 => "few",
      5 => "other",
      11 => "other",
      21 => "other",
      BigDecimal("1.5") => "many",
      BigDecimal("2.25") => "many"
    }.each do |count, expected|
      assert_equal expected, I18n.t(path, locale: :cs, count: count), "count=#{count}"
    end
  end

  test "selects Czech forms for a real holdings translation" do
    assert_equal "1 jednotka", I18n.t("holdings.holding.shares", locale: :cs, count: 1, qty: 1)
    assert_equal "3 jednotky", I18n.t("holdings.holding.shares", locale: :cs, count: 3, qty: 3)
    assert_equal "5 jednotek", I18n.t("holdings.holding.shares", locale: :cs, count: 5, qty: 5)
    assert_equal "1.5 jednotky", I18n.t(
      "holdings.holding.shares",
      locale: :cs,
      count: BigDecimal("1.5"),
      qty: "1.5"
    )
  end
end
