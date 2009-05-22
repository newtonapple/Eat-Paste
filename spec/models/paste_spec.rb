require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Paste do
  before(:each) do
    @valid_attributes = {
      :default_language => 'plain_text',
      :body => "Ruby and Python are two of my favorite programming languages.\nI love them!\nYou should try 'em!\n",
      :tag_names => 'ruby, python, programming languages'
    }
  end

  it "should create a new instance given valid attributes" do
    paste = Paste.create!(@valid_attributes)
    paste.tags.size.should == 3
    paste.line_count.should == 3
    paste.preview.should_not be_blank  
  end
  
  
  describe Paste, '#tag_names=' do
    before(:each) do
      @existing_tag_size = 3
      @existing_tag_names = "foo, bar,  baz"
      @existing_tags = @existing_tag_names.split(',').collect{ |tag_name| Tag.create! :name => tag_name }.sort_by(&:name)
    end
    
    it 'saves existing tags for new record' do
      paste = Paste.new :tag_names => @existing_tag_names, :body => ''
      paste.tags.size == @existing_tags.size
      paste.save
      paste.reload
      paste.tags.should == @existing_tags
    end
    
    it 'saves existing and new tags for new record' do
      new_tag_names = "aaa, bbb"
      tag_names = @existing_tag_names + ',' + new_tag_names    # not sorted
      tag_names_array = tag_names.split(',').map(&:strip).sort # sorted
      
      paste = Paste.new :tag_names => tag_names, :body => ''
      paste.tags.size == tag_names_array.size
      paste.save
      paste.reload
      paste.tag_names.should == tag_names_array.join(', ')
    end
  end # Paste#tag_names
  
end
