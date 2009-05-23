# paste_having_fulltext_search.rb
class Paste < ActiveRecord::Base  
  BODY_FULLTEXT_MATCH = "MATCH(#{table_name}.body) AGAINST (? IN BOOLEAN MODE)".freeze
  BODY_FULLTEXT_ALIAS = "#{BODY_FULLTEXT_MATCH} AS ?".freeze
  TAGS_QUERY = /^(?:t\[(.+)?\])?(.*)/.freeze
  
  
  named_scope :body_fulltext_match, lambda { |options|
    against = options[:against] || options[:with]
    search_scope = {:conditions => [BODY_FULLTEXT_MATCH, against]}
    if options[:as]
      fulltext_select = sanitize_sql_array([BODY_FULLTEXT_ALIAS, against, options[:as]])
      search_scope[:select] =  scope(:find)[:select] ? "#{scope[:select]}, #{fulltext_select}" : "*, #{fulltext_select}"
    end
    search_scope
  }
  
  
  named_scope :having_tag_ids, lambda {|tag_ids|
    { :joins=>[:taggings],  :conditions => {:taggings=>{:tag_id=>tag_ids}}, :group => 'pastes.id', :having => "count(pastes.id) = #{tag_ids.size}" }
  }
  
  
  def self.search( query )
    tag_names, query = *parse_search_query(query)
    tag_ids = Tag.ids_by_names(tag_names)
    if tag_ids.empty? and query.empty?     # empty set
      []
    elsif tag_ids.empty? and query.any?    # query only
      body_fulltext_match(:against=>query)
    elsif tag_ids.any? and query.empty?    # tag only
      having_tag_ids(tag_ids)
    else                                   # tag and query
      body_fulltext_match(:against=>query).having_tag_ids(tag_ids)
    end
  end
  
  
  def self.parse_search_query( query )
    if query =~ TAGS_QUERY
      tags  = $1 ? Tag.comma_seperated_names_to_array($1) : []      
      query = $2.strip
      [tags, query]
    else
      raise 'search query parser bug!'
    end
  end
  
  
  def self.exclude_or_merge_tag_name_to_search_query( tag_name, query='', queried_tag_names={} )
    query ||= '' 
    queried_tag_names ||= {}
    
    tag_names = queried_tag_names.keys
    if queried_tag_names[tag_name]
      tag_names.delete(tag_name)
      tag_names.any? ? "t[#{tag_names.sort.join(',')}] #{query}".strip : query.strip
    else 
      # note that tag_names here can never exceed max # of tags in real usage because filters always narrow down.
      tag_names.unshift(tag_name)      
      "t[#{tag_names.sort.join(',')}] #{query}".strip
    end
  end
  
end
