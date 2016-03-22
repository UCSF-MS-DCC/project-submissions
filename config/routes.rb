Rails.application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :projects
  resources :publications
  resources :fundings
  resources :dictionary
  resources :sysadmin

  root 'welcome#index'

  get "*path", to: 'application#raise_not_found'
  
end
