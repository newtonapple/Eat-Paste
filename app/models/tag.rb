class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :pastes, :through => :taggings
  
  BLACKLISTED_NAME_CHARACTERS = /[<>&"\(\)\{\}\[\]\`;]/.freeze
  
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
  
  
  def self.ids_by_names( names )
    find(:all, :select=>'id', :conditions=>{:name=>names}).map(&:id)
  end
  
  
  def name=( name )
    self[:name] = name.to_s.downcase.gsub(BLACKLISTED_NAME_CHARACTERS, ' ').squish
  end
end
