LanguageMap::Application.routes.draw do

  root to: 'data#map'

  resource :data, only: [:show] do
    collection do
      post :upload_csv
      get  :map
      get  :map_json
    end
  end

  resources :repositories, only: :index

end
