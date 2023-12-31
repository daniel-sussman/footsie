class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_player!

     protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :description, :address, :gender, :email, :password, :photo)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :description, :address, :gender, :email, :password, :current_password, :photo)}
          end

end
