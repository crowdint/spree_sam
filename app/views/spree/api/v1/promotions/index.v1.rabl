object false
node(:count) { @promotions.count }
node(:total_count) { @promotions.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @promotions.num_pages }
child(@promotions => :promotions) do
  extends "spree/api/v1/promotions/show"
end
