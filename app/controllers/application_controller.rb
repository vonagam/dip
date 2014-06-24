class ApplicationController < ActionController::Base
  respond_to :html, :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  def root
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :login
    devise_parameter_sanitizer.for(:sign_in) << :login
    devise_parameter_sanitizer.for(:account_update) << :login
  end

  def authenticate_active_admin_user!
    authenticate_user!
    redirect_to root_path unless current_user.admin?
  end
end
