Rails.application.routes.draw do
  devise_for :users
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: "pages#home"

  get 'scraping', to: "bills#scraping"

  resources :split_members, only: [] do
    collection do
      delete :destroy
    end
  end

  resources :items, only: [:destroy] do
    member do
      post :assign_members
    end
  end

  resources :bills, only: [:edit, :update]

  resources :splits, only: %i[index show new create destroy] do
    collection do
      get :invite
    end

    resources :split_members, only: %i[create]
    resources :members, only: %i[create index]

    get :add_members
    get "add_existing_contact/:member_id", to: "splits#add_existing_contact", as: :add_existing_contact

    resources :bills, only: %i[index show new create update destroy] do
      collection do
        get :receipt
        post :upload
      end

      resources :items, only: %i[index new create edit update destroy]
    end
  end

  resources :members, only: [] do
    collection do
      get :contact_lookup
    end
  end
end

# splits/9382d98d392j3d/tabulate
