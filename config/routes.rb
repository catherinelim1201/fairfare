Rails.application.routes.draw do
  devise_for :users
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :splits, only: %i[index show new create destroy] do
    resources :split_members, only: %i[create]
    resources :members, only: %i[create index]
    resources :contacts, only: %i[create index] do
      collection do
        get :filter
      end
    end

    get :add_members
    get "add_existing_contact/:member_id", to: "splits#add_existing_contact", as: :add_existing_contact

    resources :bills, only: %i[index show new create destroy] do
      collection do
        get :receipt
        post :upload
        get :select
      end

      resources :items, only: %i[index new create edit update destroy] do
        resources :item_members, only: %i[new create destroy]
      end
      resources :payers, only: %i[new create destroy]
    end

    resources :items, only: %i[destroy]
  end

  # resources :payers, only: %i[destroy]
end

# def tabulate
#   @split = Split.find_by(invite_code: params[:id])
# end

# splits/9382d98d392j3d/tabulate
