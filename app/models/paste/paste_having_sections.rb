# paste_having_sections.rb
class Paste < ActiveRecord::Base
  
  
  def fetch_section( index )
    sections.fetch(index.to_i)
  rescue IndexError
    raise Section::SectionNotFound
  end
  
  
  def sections
    @sections ||= Section.parse(body, default_language)
  end
  
  
  # Instead of actual association, we'll use a virtual Section object
  class Section
    
    # Error
    SectionNotFound = Class.new(ActiveRecord::RecordNotFound)
    
    SECTION_PATTERN = /^## (.+) \[(.*)\]\s*$\n/.freeze
    
    attr_accessor :title, :language, :body
    
    # Poor-man's parser
    def self.parse( body, default_language )
      sections = []
      body.strip.shatter(SECTION_PATTERN).each do |token|
        if token =~ SECTION_PATTERN
          sections << new($1, $2)
        elsif sections.empty?
          new_section = new('', default_language )
          new_section.body = token.rstrip
          sections << new_section
        else
          sections.last.body = token.rstrip
        end
      end
      sections
    end
    
    
    def highlighting_language
      Paste.language_or_default(language)
    end
    
    
    def highlighted_body
      Paste.syntax_highlight(body, highlighting_language)
    end
    
    
    def initialize( title, language )
      self.title, self.language, self.body = title, language, ''
    end
  end  # Section
end # Paste