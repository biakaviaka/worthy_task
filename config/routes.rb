Rails.application.routes.draw do
  get '/recent_deals/:carat/:shape/:color/:clarity', to: 'recent_deals#predict_price', as: 'predict_price'

  root to: "recent_deals#calculate"
end
