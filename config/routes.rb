Rails.application.routes.draw do
  root 'top#index'
  get 'login', to: 'top#login'

  resources :users

  resources :sessions, only: [:create, :destroy]

  namespace 'api' do
    namespace 'v1' do
      resources :users
    end
  end
end
