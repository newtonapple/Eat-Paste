require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PastesController do

  #Delete these examples and add some real ones
  it "should use PastesController" do
    controller.should be_an_instance_of(PastesController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
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
    it "should be successful" do
      paste = mock_model(Paste, :id => 1)
      Paste.should_receive(:find).with("1").and_return(paste)
      get :show, :id => "1"
      response.should be_success
      assigns[:paste].should == paste
    end
  end
end
