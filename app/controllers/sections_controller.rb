class SectionsController < ApplicationController
  caches_page :show
  
  def show
    @paste = Paste.find(params[:paste_id])
    @section = @paste.fetch_section(params[:id])
    respond_to do |wants|
      wants.text {  render :text => @section.body }
    end
  end
end
