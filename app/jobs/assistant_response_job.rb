class AssistantResponseJob < ApplicationJob
  queue_as :high_priority

  def perform(message, assistant_message = nil)
    user = message.chat.user
    locale = user.locale.presence || user.family.locale.presence || I18n.default_locale

    I18n.with_locale(locale) do
      message.request_response(assistant_message: assistant_message)
    end
  end
end
