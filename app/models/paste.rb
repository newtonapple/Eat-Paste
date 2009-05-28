class Paste < ActiveRecord::Base
  before_save :generate_line_count, :generate_preview
  
  has_many :taggings, :dependent => :delete_all
  has_many :tags, :through => :taggings, :order => 'tags.name ASC'
  having :linguistics, :search, :sections
  
  default_scope :order => 'id DESC'
  named_scope :previews, :select => "pastes.id, pastes.line_count, pastes.default_language, pastes.preview, pastes.created_at"
  
  
  def copiable_attributes
    {:default_language => default_language, :body => body, :tag_names => tag_names}
  end
  
  
  def new_copy
    self.class.new copiable_attributes
  end
  
  
  def tag_names
    tags.collect{|tag| tag.name}.join(', ')
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
    
    def generate_line_count
      self.line_count = body.split("\n").size
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
