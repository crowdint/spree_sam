Spree::Api::V1::ProductsController.class_eval do
  def stock_items
    authorize! :read, Spree::StockItem
    @stock_items = find_product(params[:id]).stock_items.ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
    respond_with(@stock_items)
  end
end