class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :paste_id, :null => false
      t.integer :tag_id,   :null => false
      t.timestamps
    end
    add_index :taggings, [:paste_id, :tag_id], :unique => true
  end

  def self.down
    drop_table :taggings
  end
end
