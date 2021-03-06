class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
  	sign_in_url = new_user_session_url
    if request.referer == sign_in_url # not sure what this does
      super
    else
      stored_location_for(resource) || root_path
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:warning] = 'Resource not found.'
    puts "\n\n ****** redirect_back_or root_path ****\n"
    redirect_back_or root_path
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  module MessagesHelper
    def recipients_options
      s = ''
      User.all.each do |user|
        s << "<option value='#{user.id}'>#{user.name}</option>"
      end
      s.html_safe
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :zip) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password, :zip, :country, :avatar) }
  end

end
