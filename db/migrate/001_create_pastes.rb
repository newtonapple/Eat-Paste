class CreatePastes < ActiveRecord::Migration
  def self.up
    execute "
      CREATE TABLE `pastes` (
        `id` int(11) NOT NULL auto_increment,
        `default_language` varchar(50) default 'plain_text',
        `body` mediumtext,
        `preview` text,
        `line_count` int(11),
        `created_at` datetime default NULL,
        `updated_at` datetime default NULL,
        PRIMARY KEY  (`id`),
        FULLTEXT KEY `fulltext_index_on_pastes_body` (`body`)
      ) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
    ".squish
  end

  def self.down
    drop_table :pastes
  end
end
