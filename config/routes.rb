Rails.application.routes.draw do
  root 'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/hell',    to: 'static_pages#hell',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  match 'users/unsubscribe/:signature', to: 'users#unsubscribe', as: 'unsubscribe', via: 'get'

  resources :users do
    member do
      get :confirm_email
      get :following, :followers
    end
  end

  resources :microposts,      only: [:create, :destroy]
  resources :relationships,   only: [:create, :destroy]
  resources :sessions,        only: [:new, :destroy, :create]

  resources :password_resets, only: [:new, :create]
  match '/password_resets/:password_reset_token/edit', to: 'password_resets#edit', as: 'edit_password_reset', via: 'get'
  match '/password_resets/:password_reset_token', to: 'password_resets#update', as: 'password_reset', via: 'patch'
end
