class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :limit => 50, :null => false
      t.integer :taggings_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
