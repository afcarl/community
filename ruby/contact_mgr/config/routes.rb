Rails.application.routes.draw do

  resources :contacts

  get  'new_contact' => 'contacts#new'

  root :to => 'contacts#index'

end
