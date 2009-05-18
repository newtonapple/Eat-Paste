require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Paste do
  before(:each) do
    @valid_attributes = {
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    Paste.create!(@valid_attributes)
  end
  
  
  # describe Paste, 'search' do
  #   
  # end
  
  
  describe Paste, 'parse_search_query' do
    
    it 'parses tags with a query begins with t[tag1, tag2, tag3] but empty query' do
      tags, query = *Paste.parse_search_query( 't[aaa, bbb, ccc, ddd, eee]' )
      tags.should == ['aaa', 'bbb', 'ccc', 'ddd', 'eee']
      query.should be_empty
    end
    
    
    it 'parses query without tags' do
      tags, query = *Paste.parse_search_query( 'ruby on rails' )
      tags.should be_empty
      query.should == 'ruby on rails'
    end
    
    
    it "ignores the t[] when the query doesn't begin with t[]" do
      tags, query = *Paste.parse_search_query( '  t[aaa, bbb, ccc, ddd, eee]' )
      tags.should be_empty
      query.should == 't[aaa, bbb, ccc, ddd, eee]'
    end
    
    
    
    it 'noramlizes tags & query' do
      tags, query = *Paste.parse_search_query( 't[hello, hello world, hello world!, HELLO WORLD!, fun!,   abc,  truncated]   ruby on rails  ' )
      tags.should == ['hello', 'hello world', 'hello world!', 'fun!', 'abc']
      query.should == 'ruby on rails'
    end
    
  end
  
  
  describe Paste::Section do 
    
    it 'breaks up body into multiple sections' do
      ruby_body = "
        class Foo < Bar
          def baz
            puts 'baz'
          end
        end".strip
        
      python_body = "
        class Foo(Bar):
          def baz():
            print('baz')".strip
          
      body = ["## Section 1 [ruby]  ", ruby_body, "## Section 2 [python]  ", python_body, "## Unknown Section [unknown language]"].join("\n")
      paste = Paste.new(:body => body)
      sections = paste.sections
      sections.size.should == 3
      sections[0].title.should == "Section 1"
      sections[1].title.should == 'Section 2'
      sections[2].title.should == 'Unknown Section'
      sections[0].language.should == "ruby"
      sections[1].language.should == 'python'
      sections[2].language.should == 'unknown language'
      sections[0].body.should == "#{ruby_body}\n"
      sections[1].body.should == "#{python_body}\n"
      sections[2].body.should == ''
    end
    
    
    it 'parses single section without headers' do
      body = "foo\nbar\nbaz"
      paste = Paste.new(:body => body)
      sections = paste.sections
      sections.size.should == 1
      section = sections.first
      section.title.should 
    end
    
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
  end
  
end
