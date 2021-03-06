Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :transactions, only: %i[] do
    collection do
      post :transfer
      get '', action: :last
      get '/:account_id', action: :single
    end
  end

  resources :accounts,  only: %i[] do
    collection do
      get '/:account_id', action: :single
    end
  end
end
