# The shape of data expected by `confirm_dialog_controller.js` to override the
# default browser confirm API via Turbo.
class CustomConfirm
  RESOURCE_TRANSLATION_KEYS = {
    "account" => "account",
    "chat" => "chat",
    "import" => "import",
    "your account" => "your_account"
  }.freeze

  class << self
    def for_resource_deletion(resource_name, high_severity: false)
      display_name = localized_resource_name(resource_name)

      new(
        destructive: true,
        high_severity: high_severity,
        title: I18n.t("shared.custom_confirm.delete_title", name: display_name),
        body: I18n.t("shared.custom_confirm.delete_body"),
        btn_text: I18n.t("shared.custom_confirm.delete_btn_text")
      )
    end

    private
      def localized_resource_name(resource_name)
        translation_key = RESOURCE_TRANSLATION_KEYS[resource_name.to_s]
        return resource_name unless translation_key

        I18n.t("shared.custom_confirm.resources.#{translation_key}")
      end
  end

  def initialize(title: default_title, body: default_body, btn_text: default_btn_text, destructive: false, high_severity: false)
    @title = title
    @body = body
    @btn_text = btn_text
    @btn_variant = derive_btn_variant(destructive, high_severity)
  end

  def to_data_attribute
    {
      title: title,
      body: body,
      confirmText: btn_text,
      variant: btn_variant
    }
  end

  private
    attr_reader :title, :body, :btn_text, :btn_variant

    def derive_btn_variant(destructive, high_severity)
      return "primary" unless destructive
      high_severity ? "destructive" : "outline-destructive"
    end

    def default_title
      I18n.t("shared.custom_confirm.default_title")
    end

    def default_body
      I18n.t("shared.custom_confirm.default_body")
    end

    def default_btn_text
      I18n.t("shared.custom_confirm.default_btn_text")
    end
end
