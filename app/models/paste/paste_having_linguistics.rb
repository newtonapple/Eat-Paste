# paste_having_fulltext_search.rb

class Paste < ActiveRecord::Base
  LANGUAGES = Uv.syntaxes.sort.freeze
  
  
  def self.language_or_default( language )
    language.to_s.in?(LANGUAGES) ? language : default_language
  end
  
  
  def self.default_language
    columns_hash['default_language'].default
  end
  
  
  def self.syntax_highlight( content, language )
    Uv.parse content, 'xhtml', language, true, 'dawn'
  end
end

