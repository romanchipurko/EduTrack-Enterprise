Rails.application.config.after_initialize do
  Rails.application.routes.default_url_options[:locale] ||= I18n.default_locale
end
