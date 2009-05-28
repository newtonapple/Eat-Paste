require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SectionsController do
  integrate_views
  
  #Delete these examples and add some real ones
  it "should use SectionsController" do
    controller.should be_an_instance_of(SectionsController)
  end

  describe 'Routes' do
    it 'matches /pastes/:paste_id/sections/:id' do
      params_from(:get, '/pastes/100/sections/0').should == {:controller=>'sections', :action=>'show', :paste_id=>'100', :id => '0' }
    end
  end
  
  
  describe "GET 'show' text format" do
    before :each do 
      body =  [
        '## Section 1 [plain_text]', 
        'hello world',
        '## Section 2 [ruby]',
        "class Hello\n  def world\n  'world'\n end"
      ]
      @section_bodies = [body[1], body[3]]
      @paste = Paste.create :body => body.join("\n")
    end
    
    it "should be successful" do
      get 'show', :paste_id => @paste, :id => 0, :format => 'text'
      response.should be_success
      response.body.rstrip.should == @section_bodies[0]
      
      get 'show', :paste_id => @paste, :id => 1, :format => 'text'
      response.should be_success
      response.body.rstrip.should == @section_bodies[1]
    end

    it "should redirect to 404" do
      lambda {
        get 'show', :paste_id => @paste, :id => 2, :format => 'text'
      }.should raise_error(Paste::Section::SectionNotFound)
    end
  end
  
  
  describe "Named Rotues" do
    it 'should route paste_section_path() correctly' do
      paste = stub_model(Paste, :id => 1)
      paste_section_path(paste, 0).should == '/pastes/1/sections/0'
    end
  end
end
