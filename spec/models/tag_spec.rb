require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :taggings_count => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Tag.create!(@valid_attributes)
  end
  
  
  
  
  describe Tag, '#get_all_new_or_by_names' do
    
    it 'returns new tags when none found' do
      tag_names = %w[foo bar baz]
      tags = Tag.get_all_new_or_by_names tag_names
      tags.each_with_index do |tag, i|
        tag.should be_new_record
        tag.name.should == tag_names[i]
      end
    end
    
    
    it 'returns existing and new tags when some found' do
      existing_tag_names = %w[foo bar baz]
      new_tag_names = %w[aaa bbb]
      tag_names = (new_tag_names + existing_tag_names).sort_by{ rand }
      existing_tags = existing_tag_names.collect{ |tag_name| Tag.create! :name => tag_name }
      
      tags = Tag.get_all_new_or_by_names( tag_names )
      tags.size.should ==  tag_names.size
      
      new_tags, old_tags = [], []
      tags.each do |tag|
        if tag.new_record?
          tag.name.should be_in(new_tag_names)
          new_tags << tag
        else
          tag.name.should be_in(existing_tag_names)
          old_tags << tag
        end
      end
      new_tags.size.should == new_tag_names.size
      existing_tags.size.should == existing_tag_names.size
    end
    
  end
  
  
end
