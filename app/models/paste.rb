class Paste < ActiveRecord::Base
  has_many :taggings, :dependent => :delete_all
  has_many :tags, :through => :taggings, :order => 'tags.name ASC'
  
  before_save :clean_body
  
  
  # Instead of actual association, we'll use a virtual Section object
  class Section
    attr_accessor :title, :language, :body
    
    SECTION_PATTERN = /^## (.+) \[(\w+)\]\W*/.freeze
    
    # Poor-man's parser
    def self.parse( body, default_language='plain_text' )
      sections = []
      body.strip.shatter(SECTION_PATTERN).each do |token|
        if token =~ SECTION_PATTERN
          sections << new($1, $2)
        elsif sections.empty?
          new_section = new('', default_language)
          new_section.body = "#{token}"
          sections << new_section
        else
          sections.last.body = "#{token}"
        end
      end
      sections
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
    self.tags = Tag.get_all_new_or_by_names normalize_tag_names(tag_names)
  end
  
  
  def body=( body )
    body.strip!
    self[:body] = body
  end
  
  
  private 
  
    def clean_body
      self.body = body.strip
    end
    
    def normalize_tag_names( tag_names )
      tag_names = tag_names.split(',')
      tag_names.map(&:strip!)
      tag_names.uniq!
      tag_names.reject!(&:empty?)
      tag_names.to(4)  # max 5 tags
    end
    
end
