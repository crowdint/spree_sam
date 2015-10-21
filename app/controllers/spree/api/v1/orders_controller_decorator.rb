Spree::Api::V1::OrdersController.class_eval do

  def approve
    authorize! :approve, @order, params[:token]
    @order.approved_by(current_api_user)
    respond_with(@order, :default_template => :show)
  end

  def cancel
    authorize! :update, @order, params[:token]
    @order.canceled_by(current_api_user)
    respond_with(@order, :default_template => :show)
  end


end