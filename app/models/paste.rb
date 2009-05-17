class Paste < ActiveRecord::Base
  before_save :clean_body, :generate_preview
  
  has_many :taggings, :dependent => :delete_all
  has_many :tags, :through => :taggings, :order => 'tags.name ASC'
  
  
  LANGUAGES = Uv.syntaxes.freeze
  BODY_FULLTEXT_MATCH = "MATCH(#{table_name}.body) AGAINST (? IN BOOLEAN MODE)".freeze
  BODY_FULLTEXT_ALIAS = "#{BODY_FULLTEXT_MATCH} AS ?".freeze
  
  default_scope :order => 'id DESC'
  
  named_scope :body_fulltext_match, lambda { |options|
    against = options[:against] || options[:with]
    search_scope = {:conditions => [BODY_FULLTEXT_MATCH, against]}
    if options[:as]
      fulltext_select = sanitize_sql_array([BODY_FULLTEXT_ALIAS, against, options[:as]])
      search_scope[:select] =  scope(:find)[:select] ? "#{scope[:select]}, #{fulltext_select}" : "*, #{fulltext_select}"
    end
    search_scope
  }
  
  
  def self.language_or_default( language )
    language.to_s.in?(LANGUAGES) ? language : default_language
  end
  
  
  def self.default_language
    columns_hash['default_language'].default
  end
  
  
  def self.search( query )
    
  end
  
  
  def self.parse_search_query( query )
    if query =~ /^(?:t\[(.+)?\])?(.*)/
      tags  = $1 ? Tag.comma_seperated_names_to_array($1) : []      
      query = $2
    else
      raise 'search query parser bug!'
    end
  end
  
  def self.syntax_highlight( content, language )
    Uv.parse content, 'xhtml', language, true, 'dawn'
  end
  
  
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
  
  
  def tag_names
    taggings.empty? ? '' : tags.collect{|tag| tag.name}.join(', ')
  end
  
  
  def tag_names=( tag_names )
    self.tags = Tag.get_all_new_or_by_names Tag.comma_seperated_names_to_array(tag_names)
  end
  
  
  def default_language=( language )
    self[:default_language] = self.class.language_or_default(language)
  end
  
  
  def body=( body )
    body.strip!
    self[:body] = body
  end
  
  
  private 
  
    def clean_body
      self.body = body.strip
    end
    
    
    def generate_preview
      i, lines = 0, []
      body.each_line do |line|
        break if i >= 5
        lines << line
        i += 1
      end
      self.preview = self.class.syntax_highlight(lines.join().to(1024), default_language)
    end
    
end
