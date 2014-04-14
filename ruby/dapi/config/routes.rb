
Dapi::Application.routes.draw do

  get  "cases/index"

  get  "labels/index"
  post "labels/create"

  root :to => "cases#index"

end
