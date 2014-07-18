class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  respond_to :html, :json

  before_action :configure_permitted_parameters, if: :devise_controller?

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

  def searching( relation, conditions )
    return relation if conditions.blank?

    relation.and *(conditions.map do |key, value|
      { key.to_sym.send( value[0] ) => value[1] }
    end)
  end
end
