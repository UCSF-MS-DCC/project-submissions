Rails.application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :projects, only: [:index, :new, :create]
  resources :publications, only: [:index]
  resources :fundings, only: [:index]
  resources :dictionary, only: [:index]
  resources :sysadmin

  root 'welcome#index'

  get "*path", to: 'application#raise_not_found'
  
end
