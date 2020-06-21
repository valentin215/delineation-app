Rails.application.routes.draw do
  root to: 'delineations#index'  

  # get '/delineation/index', to: 'delineations#index'
  post '/delineation/import_csv', to: 'delineations#import_csv'
  get '/delineation/export_csv', to: 'delineations#export_csv'
end
