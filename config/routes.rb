Rails.application.routes.draw do
  root 'top#index'
  get 'login', to: 'top#login'
  resources :users, param: :name
  resources :apps, param: :appid

  resources :sessions, only: [:create, :destroy]

  get '/:appid', to: 'apps#show'

  namespace 'api' do
    namespace 'v1' do
      resources :users
    end
  end
end
