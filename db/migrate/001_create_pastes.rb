class CreatePastes < ActiveRecord::Migration
  def self.up
    create_table :pastes, :options => 'ENGINE=MyISAM' do |t|
      t.string :default_language, :limit => 50, :default => 'plain_text'
      t.text :body, :default => ''
      t.text :preview
      t.timestamps
    end
    execute 'CREATE fulltext INDEX fulltext_idx_pastes_body ON pastes(body);'
  end

  def self.down
    drop_table :pastes
  end
end
