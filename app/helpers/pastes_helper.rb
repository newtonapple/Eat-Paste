module PastesHelper
  def syntax_highlight( content, language )
    Uv.parse content, 'xhtml', language, true, 'dawn'
  end  
end
