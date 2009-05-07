class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :pastes, :through => :taggings
end
