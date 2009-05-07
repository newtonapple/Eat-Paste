class Paste < ActiveRecord::Base
  has_many :taggings
  has_many :tags, :through => :taggings
  
  def tag_names
    tags.collect{|tag| tag.name}.join(', ')
  end
  
  def tag_names=(tag_names)
    tag_names = tag_names.split(',').collect(&:strip) if tag_names.is_a?(String)
      
  end
end
