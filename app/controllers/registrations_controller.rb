class RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)

    loc = Geokit::Geocoders::GoogleGeocoder.geocode(params[:zip])
    resource.lng = loc.lng
    resource.lat = loc.lat
    resource.save
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :zip, :country)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :zip, :country, :avatar)
  end

end
