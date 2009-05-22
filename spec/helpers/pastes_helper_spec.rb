require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PastesHelper do
  
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(PastesHelper)
  end


  describe PastesHelper, '#search_path_for_tag_name' do
    
    it 'includes tag_name in search_pastes_path even when tag_names and query are not defined' do
      CGI.unescape(helper.search_path_for_tag_name('foo')).should == '/pastes/search?q=t[foo]'
    end
    
    it 'includes tag_name in search_pastes_path when there are no other tags in search query' do
      assigns[:tag_names] = {}
      assigns[:query] = 'some search terms'
      CGI.unescape(helper.search_path_for_tag_name('foo')).should == '/pastes/search?q=t[foo] some search terms'
      assigns[:query] = ''
      CGI.unescape(helper.search_path_for_tag_name('foo')).should == '/pastes/search?q=t[foo]'
    end
    
    
    it 'includes tag_name to search_pastes_path if it already exists in search query' do
      assigns[:tag_names] = {'bar'=>'bar'}
      assigns[:query] = 'some search terms'
      path = CGI.unescape(helper.search_path_for_tag_name('foo'))
      path.should match(/^\/pastes\/search\?q=t\[\w+,\w+\] some search terms$/)
      path.should match(/^\/pastes\/search\?q=t\[.*foo.*\] some search terms$/)
      path.should match(/^\/pastes\/search\?q=t\[.*bar.*\] some search terms$/)
    end
    
    
    it 'excludes tag_name from search_pastes_path if it exists in queried tag names' do
      assigns[:tag_names] = {'foo'=>'foo', 'bar' => 'bar'}
      assigns[:query] = 'some search terms'
      CGI.unescape(helper.search_path_for_tag_name('foo')).should == '/pastes/search?q=t[bar] some search terms'
    end
    
    it 'returns only /pastes path combined query is empty' do
      assigns[:tag_names] = {'foo'=>'foo'}
      assigns[:query] = ''
      CGI.unescape(helper.search_path_for_tag_name('foo')).should == '/pastes'
    end
  end
end
