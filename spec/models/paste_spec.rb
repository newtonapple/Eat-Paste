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
          
      body = ["## Section 1 [ruby]  ", ruby_body, "## Section 2 [python]  ", python_body, "## Unknown Section [unknown]"].join("\n")
      paste = Paste.new(:body => body)
      sections = paste.sections
      sections.size.should == 3
      sections[0].title.should == "Section 1"
      sections[1].title.should == 'Section 2'
      sections[2].title.should == 'Unknown Section'
      sections[0].language.should == "ruby"
      sections[1].language.should == 'python'
      sections[2].language.should == 'unknown'
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
  
  
end
