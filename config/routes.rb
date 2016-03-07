Rails.application.routes.draw do
  resources :authentications

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  get "auth/:provider/callback", to: "authentications#callback"

  root "pages#index"
end
