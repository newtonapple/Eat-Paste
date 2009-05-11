class CreatePastes < ActiveRecord::Migration
  def self.up
    create_table :pastes do |t|
      t.string :default_language, :limit => 50, :default => 'plain_text'
      t.text :body, :default => ''
      t.timestamps
    end
  end

  def self.down
    drop_table :pastes
  end
end
