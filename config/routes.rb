Rails.application.routes.draw do
  root 'top#index'
  get 'login', to: 'top#login'
  resources :users, param: :name do
    member do
      get :token
      get :del_token
    end
  end

  resources :apps, param: :appid do
    resources :versions, param: :public_uid
  end

  resources :versions, param: :id

  resources :sessions, only: [:create, :destroy]

  get '/:appid', to: 'apps#show'
  get '/:appid/versions/:version_name', to: 'versions#show'
  get '/apps/:appid/versions/:version_name/edit', to: 'versions#edit'

  namespace 'api' do
    namespace 'v1' do
      resources :users
      resources :apps do
        resources :versions
      end
    end
  end
end
