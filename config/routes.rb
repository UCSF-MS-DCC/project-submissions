Rails.application.routes.draw do
  # This app has grown "too big" for a single application and should be broken down into separate engines.

  devise_for :users

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :projects, only: [:index, :new, :create]
  resources :publications, only: [:index]
  resources :fundings, only: [:index]
  resources :dictionary, only: [:index]
  resources :sysadmin

  # These are the individualized routes for the myo controller. To view where each of the actions goes to,
  # check in the myo_controller followed by the action after the "#" ex: 'myo#download_redcap_data' is called
  # at the myo controller, 'download_redcap_data' method.
  post 'myo/download_redcap_data', to: 'myo#download_redcap_data'
  post 'myo/download_computed_data', to: 'myo#download_computed_data'
  get 'myo/redcap', to: 'myo#redcap'
  get 'myo/participants', to: 'myo#participants'
  get 'myo/participants/:id', to: 'myo#show_participant', as: :myo_show_participant
  patch 'myo/participant/:id', to: 'myo#update_participant'
  get 'myo/participant/:id/visits', to: 'myo#show_visits', as: :myo_show_visits
  get 'myo/visit/:id', to: 'myo#show_visit', as: :myo_show_visit
  get 'myo/participant/:id/visit', to: 'myo#new_visit'
  post 'myo/participant/:id/visit', to: 'myo#create_visit'
  post 'myo/visit', to: 'myo#create_visit'
  get 'myo/delete_file/:id', to: 'myo#delete_file'
  get 'myo/download_file/:id', to: 'myo#download_file', as: :myo_download_file
  get 'myo', to: 'myo#index'

  resources :myo, except: [:new]  do
    patch :update, :on => :collection
    post :create, :on => :collection
    patch :update_visit, :on => :collection
  end

  # routes for the goodin/bove EDSS
  get 'edss/bove', to: 'edss#bove'
  post 'edss/bove/calculate', to: 'edss#bove_calculate'

  get 'edss/goodin', to: 'edss#goodin'
  post 'edss/goodin/calculate', to: 'edss#goodin_calculate'

  get 'edss/bove2', to: 'edss#bove2'
  post 'edss/bove2a', to: 'edss#bove2a_results'

  get 'edss/bove3', to: 'edss#bove3'
  post 'edss/bove3', to: 'edss#bove3_results'

  #get 'edss/bove2b', to: 'edss#bove2b'
  post 'edss/bove2b', to: 'edss#bove2b_results'

  get 'predss', to: 'predss#index'
  post 'predss/bove3/results', to: 'predss#bove3_results'
  post 'predss/goodin/results', to: 'predss#goodin_results'

  # root, not found/authorized paths
  root 'welcome#index'
  get 'notfound', to: 'application#not_found'
  get 'notauthorized', to: 'application#not_authorized'
  get "*path", to: 'application#raise_not_found'

end