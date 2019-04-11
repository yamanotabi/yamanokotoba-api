Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, { format: 'json' } do
    namespace :v1 do
      # TODO: remove unneccesary routes
      resources :words
      resources :images
      get '/users/:user_id/words', to: 'words#getByUser'
    end
  end
end
