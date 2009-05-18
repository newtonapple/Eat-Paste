class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :paste_id, :null => false
      t.integer :tag_id,   :null => false
      t.timestamps
    end
    add_index :taggings, [:paste_id, :tag_id], :unique => true
    add_index :taggings, [:tag_id]
    add_index :taggings, [:paste_id]
  end

  def self.down
    drop_table :taggings
  end
end
