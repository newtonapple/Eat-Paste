class Tagging < ActiveRecord::Base
  belongs_to :paste
  belongs_to :tag, :autosave => true
end
