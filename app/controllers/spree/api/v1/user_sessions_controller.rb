module Spree
  module Api
    module V1
      class UserSessionsController < Devise::SessionsController
        helper 'spree/base'

        include Spree::Core::ControllerHelpers::Auth
        include Spree::Core::ControllerHelpers::Common
        include Spree::Core::ControllerHelpers::Order
        include Spree::Core::ControllerHelpers::Store

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