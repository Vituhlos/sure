class Valuation::Name
  def initialize(valuation_kind, accountable_type)
    @valuation_kind = valuation_kind
    @accountable_type = accountable_type
  end

  def to_s
    case valuation_kind
    when "opening_anchor"
      opening_anchor_name
    when "current_anchor"
      current_anchor_name
    else
      recon_name
    end
  end

  private
    attr_reader :valuation_kind, :accountable_type

    def opening_anchor_name
      case accountable_type
      when "Property", "Vehicle"
        I18n.t("valuations.names.opening_anchor.property_or_vehicle")
      when "Loan"
        I18n.t("valuations.names.opening_anchor.loan")
      when "Investment", "Crypto", "OtherAsset"
        I18n.t("valuations.names.opening_anchor.account_value")
      else
        I18n.t("valuations.names.opening_anchor.balance")
      end
    end

    def current_anchor_name
      case accountable_type
      when "Property", "Vehicle"
        I18n.t("valuations.names.current_anchor.property_or_vehicle")
      when "Loan"
        I18n.t("valuations.names.current_anchor.loan")
      when "Investment", "Crypto", "OtherAsset"
        I18n.t("valuations.names.current_anchor.account_value")
      else
        I18n.t("valuations.names.current_anchor.balance")
      end
    end

    def recon_name
      case accountable_type
      when "Property", "Investment", "Vehicle", "Crypto", "OtherAsset"
        I18n.t("valuations.names.reconciliation.value")
      when "Loan"
        I18n.t("valuations.names.reconciliation.principal")
      else
        I18n.t("valuations.names.reconciliation.balance")
      end
    end
end
