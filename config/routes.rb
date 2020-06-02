Rails.application.routes.draw do
  
  get 'room/index'
  devise_for :users
  get 'downloads/index'
  get 'timetables/index'
  get 'fiscals/index'
  get 'deposits/index'
 
  get 'customers/index'
  
  get 'home/index' => "home#index"
  get 'home/show' => "home#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  get "customers/:id/show" => "customers#show"
  get "customers/:id/new" => "customers#new"
  post "customers/:id/create" => "customers#create"  
  post "customers/:id/:cust/update" => "customers#update"
  get "customers/:id/:cust/edit" => "customers#edit"

  get "accounts/:id/index_select" => "accounts#index_select"
  post "accounts/:id/index" => "accounts#index"   #売掛金検索（単月）
  get "accounts/:id/index" => "accounts#index_select"
  get "accounts/:id/new" => "accounts#new"
  #get "accounts/:id/edit" => "accounts#edit"
  post "accounts/:id/create" => "accounts#create"
  get "accounts/:id/index_select2" => "accounts#index_select2"
  post "accounts/:id/index2" => "accounts#index2"
  get "accounts/:id/index2" => "accounts#index_select2"

  get "accounts/:id/index_select_summary" => "accounts#index_select_summary"
  post "accounts/:id/index_summary" => "accounts#index_summary"
  get "accounts/:id/index_summary" => "accounts#index_select_summary"

  get "accounts/:id/csv_test" => "accounts#csv_test"
  
  get "deposits/:id/index_select" => "deposits#index_select"
  post "deposits/:id/index" => "deposits#index"
  get "deposits/:id/index" => "deposits#index_select"
  get "deposits/:id/index_select2" => "deposits#index_select2"
  post "deposits/:id/index2" => "deposits#index2"
  get "deposits/:id/index2" => "deposits#index_select2"

  get "deposits/:id/index_select_payment" => "deposits#index_select_payment"
  post "deposits/:id/index_payment" => "deposits#index_payment"
  get "deposits/:id/index_select_payment2" => "deposits#index_select_payment2"
  post "deposits/:id/index_payment2" => "deposits#index_payment2"

  get "deposits/:id/index_select_sales" => "deposits#index_select_sales"
  post "deposits/:id/index_sales" => "deposits#index_sales"
  get "deposits/:id/index_select_sales2" => "deposits#index_select_sales2"
  post "deposits/:id/index_sales2" => "deposits#index_sales2"

  get "deposits/:id/:account_id/show"  => "deposits#show"
  post "deposits/:id/:account_id/create" => "deposits#create"

  get "fiscals/:id/new" => "fiscals#new"
  post "fiscals/:id/create" => "fiscals#create"
  get "fiscals/:id/edit" => "fiscals#edit"
  post "fiscals/:id/update" => "fiscals#update"

  get "timetables/:id/index" => "timetables#index"
  post "timetables/:id/index/1" => "timetables#index_1"
  
  get "timetables/:id/index_deposit" => "timetables#index_deposit"
  post "timetables/:id/index/2" => "timetables#index_2"

  get "downloads/:id/index" => "downloads#index"
  get "downloads/:id" => "downloads#download"

  get "room/show" => "room#show"
  
  
end
