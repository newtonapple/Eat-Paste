class PastesController < ApplicationController
  caches_page :show

  
  def index
    @pastes = Paste.previews.paginate(:page => params[:page], :count => {:select=>:id}, :per_page => 15)
    @index_tab_selected = 'selected'
    set_title "All Pastes - #{page}"
  end


  def create
    @paste = Paste.new params[:paste]
    if @paste.save
      redirect_to @paste
    else
      set_title('New Paste')
      render :action => 'new'
    end
  end


  def new
    @paste = Paste.new
    @new_tab_selected = 'selected'
    @tab_class={:eat => 'selected'}
    set_title('New Paste')
  end


  def show
    @paste = Paste.find params[:id]
    respond_to do |wants|
      wants.html { set_title "Paste ##{params[:id]}" }
      wants.text { render :text => @paste.body }
    end
  end
  
  
  def search
    @tag_names, @query = *Paste.parse_search_query(params[:q])
    @tag_names = @tag_names.index_by(&:to_s)
    @pastes = Paste.previews.search(params[:q]).paginate(:page => params[:page], :count => {:select=>'pastes.id'}, :per_page => 15)
    set_title "Search: #{params[:q]} - #{page}"
  end
  
  private 
    def set_title( title )
      @title = "#{title} @ #{request.host}"
    end
    
    def page
      params[:page] || 1
    end
end
