BaseSite::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  namespace :admin do
    root :to => 'home#index'
    
    match 'login' => 'home#login', :via => :get

    resources :users, :except => [:show]

    resources :static_texts, :except => [:show]

    resource :configurable
  end

  scope :module => 'front' do
    root :to => 'base#index'

    match 'signup' => 'users#new'
    match 'signup/complete' => 'users#signup_complete', :as => 'signup_complete'

    resources :sessions, :only => [:create]
    match 'login' => "sessions#new"
    match 'logout' => "sessions#destroy"
    
    match 'activate(/:activation_code)' => 'users#activate', :as => :activate_account
    match 'send_activation(/:user_id)' => 'users#send_activation', :as => :send_activation
    
    match 'forgot_password' => 'users#forgot_password', :as => :forgot_password, :via => :get
    match 'forgot_password' => 'users#forgot_password_lookup_email', :as => :forgot_password, :via => :post

    put 'reset_password/:reset_password_code' => 'users#reset_password_submit', :as => :reset_password, :via => :put
    get 'reset_password/:reset_password_code' => 'users#reset_password', :as => :reset_password, :via => :get

    resources :users

    match '*path' => 'pages#show', :as => 'page'
  end

end
