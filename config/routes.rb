ActionController::Routing::Routes.draw do |map|
  map.resources :pastes, :except => [:edit, :destroy], :collection => {:search => :get}, :member => {:refeed => :get} do |paste|
    paste.resources :sections, :only => [:show]
  end
  
  map.root :controller => 'pastes', :action => 'new'
end
