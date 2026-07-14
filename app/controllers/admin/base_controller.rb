module Admin
  class BaseController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      authorize :admin, :access?
    rescue Pundit::NotAuthorizedError
      redirect_to root_path, alert: "You have no rights for this."
    end
  end  
end
