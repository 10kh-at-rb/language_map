LanguageMap::Application.routes.draw do
  resource :data, only: [:show] do
    collection { post :upload_csv }
  end
end
