Rails.application.routes.draw do

  resources :myo_files

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :projects, only: [:index, :new, :create]
  resources :publications, only: [:index]
  resources :fundings, only: [:index]
  resources :dictionary, only: [:index]
  resources :sysadmin
  
  post 'myo/download_redcap_data', to: 'myo#download_redcap_data'
  get 'myo/redcap', to: 'myo#redcap'
  get 'myo/participants', to: 'myo#participants'
  get 'myo/participants/:id', to: 'myo#show_participant'
  patch 'myo/participant/:id', to: 'myo#update_participant'
  get 'myo/participant/:id/visits', to: 'myo#show_visits'
  get 'myo/visit/:id', to: 'myo#show_visit'
  get 'myo/participant/:id/visit', to: 'myo#new_visit'
  post 'myo/participant/:id/visit', to: 'myo#create_visit'
  post 'myo/visit', to: 'myo#create_visit'
  get 'myo/upload', to: 'myo#upload'
  get 'myo/delete_file/:id', to: 'myo#delete_file'

  resources :myo  do 
    patch :update, :on => :collection
    post :create, :on => :collection
    patch :update_visit, :on => :collection
  end


  get 'edss/bove', to: 'edss#bove'
  post 'edss/bove/calculate', to: 'edss#bove_calculate'
  get 'edss/goodin', to: 'edss#goodin'
  post 'edss/goodin/calculate', to: 'edss#goodin_calculate'


  root 'welcome#index'
  get "*path", to: 'application#raise_not_found'
  
end
