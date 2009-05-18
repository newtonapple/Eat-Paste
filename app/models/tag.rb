class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :pastes, :through => :taggings
  
  def self.get_all_new_or_by_names( names )
    tags = find_all_by_name( names )
    new_tag_names = names - tags.collect(&:name)
    tags.concat new_tag_names.collect{ |name| Tag.new :name=>name }
  end
  
  
  def self.comma_seperated_names_to_array( names, size = 5 )
    names = names.split(',')
    names.map(&:strip!)
    names.map(&:downcase!)
    names.uniq!
    names.reject!(&:empty?)
    names.to(size - 1)  # max 5 tags
  end
  
  
  def name=( name )
    self[:name] = name.to_s.strip.downcase
  end
end
