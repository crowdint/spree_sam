module Spree
  module Api
    module V1
      class PromotionsController < Spree::Api::BaseController

        before_action :load_promotion, only: [:show, :update, :destroy]

        def index
          authorize! :read, Promotion
          @promotions = Spree::Promotion.
              ransack(params[:q]).
              result.
              page(params[:page]).
              per(params[:per_page])
          respond_with(@promotions)
        end

        def available
          respond_with({})
        end

        def create
          authorize! :create, Spree::Promotion
          @promotion = Spree::Promotion.create(promotion_params)

          set_rules_and_actions

          if @promotion.reload
            render :show, :status => 201
          else
            invalid_resource!(@promotion)
          end
        end

        def show
          authorize! :show, Spree::Promotion
          if @promotion
            respond_with(@promotion, default_template: :show)
          else
            raise ActiveRecord::RecordNotFound
          end
        end

        def update
          authorize! :update, Spree::Promotion

          @promotion.update_attributes(promotion_params)

          set_rules_and_actions

          if @promotion.reload && @promotion.errors.empty?
            render :show
          else
            invalid_resource!(@promotion)
          end
        end

        private
        def promotion_params
          params.require(:promotion).permit(:name, :description, :starts_at,
                                            :expires_at, :usage_limit, :code,
                                            :match_policy, :promotion_rules, :promotion_actions)
        end

        def load_promotion
          @promotion = Spree::Promotion.find(params[:id]) || Spree::Promotion.with_coupon_code(params[:id])
        end

        def set_rules_and_actions
          if @promotion
            @promotion.actions.destroy_all
            @promotion.rules.destroy_all
          end

          promotion_extras = params[:promotion][:promotion_rules].to_a + params[:promotion][:promotion_actions].to_a

          promotion_extras.each do |promotion_extra|
            klass = promotion_extra.delete(:type).constantize
            pe = klass.new
            pe.promotion = @promotion
            promotion_extra.each do |property, nested|
              if nested.is_a?(Hash)
                klass = promotion_extra["#{property}_type".to_sym].constantize.create(calculable: pe)
                nested.each { |key, value| klass.send("#{key}=", value) }
                klass.save
                pe.calculator.destroy
                pe.calculator = klass
              else
                pe.send("#{property}=", nested)
              end
            end
            pe.save
          end
        end
      end
    end
  end
end
