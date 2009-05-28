require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PastesController do
  integrate_views
  
  it "should use PastesController" do
    controller.should be_an_instance_of(PastesController)
  end


  describe "GET 'index'" do
    before :each do 
      @tag_name_inputs = ['foo, bar, baz', 'ruby, python, perl', 'fun, boring']
      @bodies = [ 'foo', 'ruby', 'boring' ]
      @pastes = []
      @bodies.each_with_index do |body, i|
        @pastes << Paste.create!(:body => body, :tag_names => @tag_name_inputs[i])
      end
    end
    
    it "should be successful" do
      get 'index'
      @pastes.reverse.each_with_index do |expected_paste, i|
        assigns[:pastes][i].id == expected_paste.id
        assigns[:pastes][i].preview == expected_paste.preview
      end
      response.should be_success
    end
  end
  
  
  describe "GET 'refeed'" do
    before :each do
      @paste = Paste.create :default_language => 'ruby', :body => 'puts "hello world"', :tag_names => 'ruby, programming'
    end
    
    it "should be successful" do
      get 'refeed', :id => @paste
      response.should be_success
    end    

    it "should be successful" do
      get 'refeed', :id => @paste
      response.should be_success
      response.should have_tag("form[action=/pastes][method=post]") do
        with_tag ['textarea[name=?]', 'paste[body]'], :text => ERB::Util.h(@paste.body)
        with_tag ['select[name=?]', 'paste[default_language]'] do 
          with_tag ['option[value=ruby][selected=selected]']
        end
        with_tag ['input[type=text][name=?][value=?]', 'paste[tag_names]', @paste.tag_names]
      end
    end    
  end
  
  
  describe "GET search" do
    it 'should redirect to paste if #id is given as the only search query' do
      get 'search', :q => '#123'
      response.should redirect_to('/pastes/123')
    end
    
    
    it 'should redirect to paste refeed if r#id is given as the only search query' do
      get 'search', :q => 'r#123'
      response.should redirect_to('/pastes/123/refeed')
    end
  end
  
  
  describe "GET 'create'" do
    it "should be successful" do
      post :create, {:paste => {:body => 'hello'}}
      response.should be_redirect
    end
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  
  describe "GET 'show'" do
    before :each do 
      @paste = Paste.create :body => 'class A < B; def foo puts "foo"; end; end', :tag_names => 'foo, bar, baz'
    end
    
    it "should be successful" do
      get :show, :id => @paste.id
      assigns[:paste].should == @paste
      response.should be_success
    end
  end
  
  
  describe "Named Rotues" do
    it 'should route refeed_section_path() correctly' do
      paste = stub_model(Paste, :id => 1)
      refeed_paste_path(paste).should == '/pastes/1/refeed'
    end    
  end
end
