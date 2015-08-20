module Spree
  module Api
    module V1
      class UserSessionsController < Devise::SessionsController
        skip_before_action :verify_authenticity_token

        respond_to :json

        def create
          authenticate_spree_user!

          if spree_user_signed_in?
            respond_to do |format|
              format.html {
                flash[:success] = Spree.t(:logged_in_succesfully)
                redirect_back_or_default(after_sign_in_path_for(spree_current_user))
              }
              format.js {
                render json: { user: spree_current_user,
                               ship_address: spree_current_user.ship_address,
                               bill_address: spree_current_user.bill_address }, status: :ok
              }
              format.json {
                render json: { user: spree_current_user,
                               spree_api_key: spree_current_user.spree_api_key }, status: :ok
              }
            end
          else
            respond_to do |format|
              format.html {
                flash.now[:error] = t('devise.failure.invalid')
                render :new
              }
              format.js {
                render json: { error: t('devise.failure.invalid') }, status: :unprocessable_entity
              }
              format.json {
                render json: { error: t('devise.failure.invalid') }, status: :unprocessable_entity
              }
            end
          end
        end

        def destroy
          sign_out(resource_name)
          respond_to_on_destroy
        end

        private

        def respond_to_on_destroy
          respond_to do |format|
            format.all { head :no_content }
            format.json { render json: { session: 'destroyed' }, status: :ok }
            format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
          end
        end

      end
    end
  end
end