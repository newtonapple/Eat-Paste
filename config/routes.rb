ActionController::Routing::Routes.draw do |map|
  map.resources :pastes, :except => [:edit, :destroy]
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
