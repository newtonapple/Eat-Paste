class PastesController < ApplicationController
  caches_page :show
  
  
  def index
    @pastes = Paste.previews.paginate(:page => params[:page], :count => {:select=>:id}, :per_page => 15)
    @index_nav_selected = 'selected'
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
    set_for_new_action
    set_title('New Paste')
  end
  
  
  def refeed
    existing_paste = Paste.find params[:id]
    @paste = existing_paste.new_copy
    set_for_new_action
    set_title("Refeed Paste ##{existing_paste.id}")
    render :action => 'new'
  end
  
  
  def show
    @paste = Paste.find params[:id]
    respond_to do |wants|
      wants.html { set_title "Paste ##{params[:id]}" }
      wants.text { render :text => @paste.body }
    end
  end
  
  
  def search
    case params[:q].to_s
    when /^#(\d+)\s*$/
      redirect_to paste_path($1)
    when /^r#(\d+)\s*$/
      redirect_to refeed_paste_path($1)
    else
      @tag_names, @query = *Paste.parse_search_query(params[:q])
      @tag_names = @tag_names.index_by(&:to_s)
      @pastes = Paste.previews.search(params[:q]).paginate(:page => params[:page], :count => {:select=>'pastes.id'}, :per_page => 15)
      set_title "Search: #{params[:q]} - #{page}"
    end
  end
  
  
  
  
  private     
    
    def set_title( title )
      @title = "#{title} @ #{request.host}"
    end
    
    
    def set_for_new_action
      @new_nav_selected = 'selected'
      @tab_class={:eat => 'selected'}
    end
    
    
    def page
      params[:page] || 1
    end
end
