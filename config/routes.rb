Rails.application.routes.draw do
  resources :contacts, only: [:new, :create]
  #match 'oauth2callback' => 'contacts#set_google_drive_token', :via => :get
  root to: 'visitors#new'
end
