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

    # Production quantity formatting strips insignificant trailing zeros, so
    # integral Float/BigDecimal values are displayed as integers. The plural
    # rule intentionally follows that visible value; Numeric alone cannot
    # preserve whether the input was originally written as 1 or 1.0.
    [
      [ 0, "other" ],
      [ 1, "one" ],
      [ 2, "few" ],
      [ 3, "few" ],
      [ 4, "few" ],
      [ 5, "other" ],
      [ 11, "other" ],
      [ 21, "other" ],
      [ 1.0, "one" ],
      [ BigDecimal("1.0"), "one" ],
      [ 1.1, "many" ],
      [ 1.5, "many" ],
      [ 2.0, "few" ],
      [ 5.0, "other" ],
      [ BigDecimal("1.5"), "many" ],
      [ BigDecimal("2.25"), "many" ]
    ].each do |count, expected|
      assert_equal expected, I18n.t(path, locale: :cs, count: count), "count=#{count.inspect} (#{count.class})"
    end
  end

  test "selects Czech forms for a real holdings translation" do
    assert_equal "1 jednotka", I18n.t("holdings.holding.shares", locale: :cs, count: 1, qty: 1)
    assert_equal "3 jednotky", I18n.t("holdings.holding.shares", locale: :cs, count: 3, qty: 3)
    assert_equal "5 jednotek", I18n.t("holdings.holding.shares", locale: :cs, count: 5, qty: 5)
    I18n.with_locale(:cs) do
      quantity = BigDecimal("1.5")
      formatted_quantity = ApplicationController.helpers.format_quantity(quantity)

      assert_equal "1,5", formatted_quantity
      assert_equal "1,5 jednotky", I18n.t(
        "holdings.holding.shares",
        count: quantity,
        qty: formatted_quantity
      )
    end
  end

  test "translates expected recurring transaction days with Czech plural forms" do
    {
      1 => "Očekáváno za 1 den",
      2 => "Očekáváno za 2 dny",
      4 => "Očekáváno za 4 dny",
      5 => "Očekáváno za 5 dní",
      21 => "Očekáváno za 21 dní"
    }.each do |count, expected|
      assert_equal expected, I18n.t("recurring_transactions.expected_in", locale: :cs, count: count)
    end
  end
end
