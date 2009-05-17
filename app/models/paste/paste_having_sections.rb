# paste_having_sections.rb
class Paste < ActiveRecord::Base
  # Instead of actual association, we'll use a virtual Section object
  class Section
    attr_accessor :title, :language, :body
    
    SECTION_PATTERN = /^## (.+) \[(.*)\]\W*/.freeze
    
    
    # Poor-man's parser
    def self.parse( body, default_language )
      sections = []
      body.strip.shatter(SECTION_PATTERN).each do |token|
        if token =~ SECTION_PATTERN
          sections << new($1, $2)
        elsif sections.empty?
          new_section = new('', default_language )
          new_section.body = token
          sections << new_section
        else
          sections.last.body = token
        end
      end
      sections
    end
    
    
    def highlighting_language
      Paste.language_or_default(language)
    end
    
    
    def highlighted_body
      Paste.syntax_highlight(body, default_language)
    end
    
    
    def initialize( title, language )
      self.title, self.language, self.body = title, language, ''
    end
  end  # Section
  
  
  def sections
    @sections ||= Section.parse(body, default_language)
  end
end