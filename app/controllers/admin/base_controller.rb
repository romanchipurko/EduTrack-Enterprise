module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      authorize :admin, :access?
    rescue Pundit::NotAuthorizedError
      redirect_to root_path, alert: I18n.t("admin.access_denied")
    end
  end
end
