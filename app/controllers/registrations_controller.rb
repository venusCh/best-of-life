class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :zip, :country)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :zip, :country)
  end

end
