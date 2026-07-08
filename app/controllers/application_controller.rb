class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  around_action :switch_locale

  def switch_locale(&)
    I18n.with_locale(params[:locale] || I18n.default_locale, &)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
