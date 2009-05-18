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
end
