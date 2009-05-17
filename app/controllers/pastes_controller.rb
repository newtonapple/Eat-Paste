class PastesController < ApplicationController
  caches_page :show

  
  def index
    @pastes = Paste.all :select => "id, default_language, preview, created_at"
  end


  def create
    @paste = Paste.new params[:paste]
    respond_to do |wants|
      if @paste.save
        wants.html { redirect_to @paste }
      else
        wants.html { render :action => 'new' }
      end
    end
  end


  def new
    @paste = Paste.new
    respond_to do |wants|
      wants.html
    end
  end


  def show
    @paste = Paste.find params[:id]
    respond_to do |wants|
      wants.html
    end
  end
  
  
  def search
    
  end
  
end
