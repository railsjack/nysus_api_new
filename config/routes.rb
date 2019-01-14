NysusApi::Application.routes.draw do
  
  devise_for :users, :controllers => {registrations: 'registration'}

  namespace :api do
    namespace :v1  do
      
      resources :users, :only => [:show]

      resources :tokens,:only => [:create, :destroy]

      resources :specials

      resources :events

      resources :categories

      resources :establishments do

        resources :events do
          member do
            post :custom_update
          end
        end

        resources :specials do
          member do
            post :custom_update
          end
        end

        member do
          post :custom_update
          post :favorite
          post :claim
          get  :mine
          post :category
          get  :suggest
        end
      end
    end
  end
end
