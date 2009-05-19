ActionController::Routing::Routes.draw do |map|
  map.resources :pastes, :except => [:edit, :destroy], :collection => {:search => :get}
  map.root :controller => 'pastes', :action => 'new'
end
