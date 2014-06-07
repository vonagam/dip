class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
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

  def auth_user!
    redirect_to root_path unless user_signed_in?
  end

  def find_game
    @game = Game.find( params[:id] || params[:game_id] )
  end
end
