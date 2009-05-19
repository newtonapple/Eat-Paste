class PastesController < ApplicationController
  caches_page :show

  
  def index
    @pastes = Paste.previews.paginate(:page => params[:page], :count => {:select=>:id}, :per_page => 20)
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
    @tag_names, @query = *Paste.parse_search_query(params[:q])
    @tag_names = @tag_names.index_by(&:to_s)
    @pastes = Paste.previews.search(params[:q]).paginate(:page => params[:page], :count => {:select=>'pastes.id'}, :per_page => 20) 
  end
  
end
