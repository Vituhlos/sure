# rails-i18n 8.1 uses the older three-form Czech rule. Czech CLDR also
# distinguishes non-integer quantities with the `many` form, which our
# translations provide explicitly.
Rails.application.config.after_initialize do
  czech_plural_rule = lambda do |count|
    next :other unless count.is_a?(Numeric)
    next :many unless (count % 1).zero?

    case count.to_i
    when 1 then :one
    when 2, 3, 4 then :few
    else :other
    end
  end

  I18n.backend.store_translations(
    :cs,
    i18n: {
      plural: {
        keys: %i[one few many other],
        rule: czech_plural_rule
      }
    }
  )
end
