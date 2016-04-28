Rails.application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :projects, only: [:index, :new, :create]
  resources :publications, only: [:index]
  resources :fundings, only: [:index]
  resources :dictionary, only: [:index]
  resources :sysadmin
  
  post 'myo/download_redcap_data', to: 'myo#download_redcap_data'
  get 'myo/redcap', to: 'myo#redcap'
  resources :myo 


  get 'edss/bove', to: 'edss#bove'
  post 'edss/bove/calculate', to: 'edss#bove_calculate'
  get 'edss/goodin', to: 'edss#goodin'
  post 'edss/goodin/calculate', to: 'edss#goodin_calculate'


  root 'welcome#index'
  get "*path", to: 'application#raise_not_found'
  
end
