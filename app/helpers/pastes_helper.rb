module PastesHelper
  def search_path_for_tag_name( tag_name, path_options={} )
    query = h Paste.exclude_or_merge_tag_name_to_search_query(tag_name, @query, @tag_names)
    query.any? ? search_pastes_path(path_options.merge(:q => query)) : pastes_path
  end
end
