# paste_having_fulltext_search.rb

class Paste < ActiveRecord::Base
  BODY_FULLTEXT_MATCH = "MATCH(#{table_name}.body) AGAINST (? IN BOOLEAN MODE)".freeze
  BODY_FULLTEXT_ALIAS = "#{BODY_FULLTEXT_MATCH} AS ?".freeze
  
  
  named_scope :body_fulltext_match, lambda { |options|
    against = options[:against] || options[:with]
    search_scope = {:conditions => [BODY_FULLTEXT_MATCH, against]}
    if options[:as]
      fulltext_select = sanitize_sql_array([BODY_FULLTEXT_ALIAS, against, options[:as]])
      search_scope[:select] =  scope(:find)[:select] ? "#{scope[:select]}, #{fulltext_select}" : "*, #{fulltext_select}"
    end
    search_scope
  }
  
  
  def self.search( query )
    
  end
  
  
  def self.parse_search_query( query )
    if query =~ /^(?:t\[(.+)?\])?(.*)/
      tags  = $1 ? Tag.comma_seperated_names_to_array($1) : []      
      query = $2
    else
      raise 'search query parser bug!'
    end
  end
end
