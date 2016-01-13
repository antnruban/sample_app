Rails.application.routes.draw do
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :sessions,      only: [:new, :destroy, :create]

  root 'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/hell',    to: 'static_pages#hell',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
end
