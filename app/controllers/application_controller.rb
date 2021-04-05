class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    userpage_path(current_user)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :profile, :sex])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :profile, :sex, :password])
  end
end
