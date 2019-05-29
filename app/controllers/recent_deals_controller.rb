class RecentDealsController < ApplicationController
  def calculate
  end

  def predict_price
    new_deal = RecentDeals.new

    new_deal.carat_weight = params[:carat].gsub('-', '.').to_f
    new_deal.shape = params[:shape]
    new_deal.color = params[:color]
    new_deal.clarity = params[:clarity]

    price = PriceModel.predict(new_deal)
    price =  price > 0 ? "$#{price.to_i}" : "error"

    render json: {price: price}
  end
end
