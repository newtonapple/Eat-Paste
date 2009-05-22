require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Paste, 'search' do
  before :each do
    Paste.delete_all
    Tagging.delete_all
    Tag.delete_all
    @ruby_pastes = [
      Paste.create!(:body => "Ruby does not scale.", :default_language => 'ruby', :tag_names => 'ruby, scale'),
      Paste.create!(:body => "Ruby is a programmer's best friend.", :default_language => 'plain_text', :tag_names => 'ruby, programmer, best friend')
    ].reverse
    
    @python_pastes = [
      Paste.create!(:body => "Python is very elegant.", :default_language => 'python', :tag_names => 'python, programming'),
      Paste.create!(:body => "Python 3.0's file IO can be slow.", :default_language => 'python', :tag_names => 'python, file, io, programming')
    ].reverse
    
  end
  
  it 'searches with only tags' do
    rubies = Paste.search 't[ruby]'
    rubies.to_a.should == @ruby_pastes
    
    rubies = Paste.search 't[best friend, ruby]'
    rubies.to_a.size.should == 1
    rubies[0].should == @ruby_pastes[0]
    
    pythons = Paste.search 't[python, programming]'
    pythons.to_a.should == @python_pastes
  end
  
  
  it 'searches without tags' do
    Paste.search('ruBy').should == @ruby_pastes
    Paste.search('scale')[0].should == @ruby_pastes[1]
    Paste.search('python').should == @python_pastes
    Paste.search('elegant')[0].should == @python_pastes[1]
    Paste.search('slow')[0].should == @python_pastes[0]
  end
  
  
  it 'searches with tags' do
    Paste.search('t[ruby] scale')[0].should == @ruby_pastes[1]
  end
  
  
  it 'returns nothing when tags do not match' do
    Paste.search('t[ruby python]').to_a.should be_empty
    Paste.search('t[ruby, python]').to_a.should be_empty
  end
  
end # Paste.search


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
  
end # Paste.parse_search_query

describe Paste, 'exclude_or_merge_tag_name_to_search_query' do
  it 'merges tag_name to query when query and existing tag_names are nil' do
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', nil, nil)
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', nil, nil)
    query.should == 't[foo]'
  end
  
  it 'merges tag_name to query when query is blank or consiting of empty spaces' do
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', nil, {})
    query.should == 't[foo]'
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', '', {})
    query.should == 't[foo]'
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', '       ', {})
    query.should == 't[foo]'
  end
  
  
  it "merges tag_name to query if it does not already exist in query" do
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', 'some query', 'bar'=> 'bar', 'baz' => 'baz')
    query.should match(/^t\[\w+,\w+,\w+\] some query$/)
    query.should match(/t\[.*foo.*\]/)
    query.should match(/t\[.*bar.*\]/)
    query.should match(/t\[.*baz.*\]/)
  end
  
  it "excludes tag_name from query if it already exists in query" do
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', 'some query', 'foo'=>'foo', 'bar'=>'bar', 'baz' => 'baz')
    query.should match(/^t\[\w+,\w+\] some query$/)
    query.should_not match(/t\[.*foo.*\]/)
    query.should match(/t\[.*bar.*\]/)
    query.should match(/t\[.*baz.*\]/)
  end
  
  it "returns only query when the last tag is excluded" do
    query = Paste.exclude_or_merge_tag_name_to_search_query('foo', 'some query', 'foo'=>'foo')
    query.should == 'some query'
  end
end