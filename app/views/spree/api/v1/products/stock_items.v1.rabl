object false
node(:count) { @stock_items.count }
node(:total_count) { @stock_items.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @stock_items.num_pages }

node(:stock_items) do
  @stock_items.collect do |stock_item|
    {
      id: stock_item.id,
      count_on_hand: stock_item.count_on_hand,
      variant_id: stock_item.variant_id,
      stock_location_id: stock_item.stock_location_id,
      stock_movements: stock_item.stock_movements.last(3)
    }
  end
end
