module CommunityTrackPlugin::TrackHelper

  def category_class(track)
    'category_' + (track.categories.empty? ? 'not_defined' : track.categories.first.name.to_slug)
  end

  def track_card_lead(track)
    lead_stripped = strip_tags(track.lead)
    excerpt(lead_stripped, lead_stripped.first(3), track.image ? 180 : 300)
  end

  def track_color_style(track, bg = true)
    color = nil
    if !track.categories.empty?
      color = search_category_tree_for_color(track.categories.first)
    end
    if color.nil?
      ''
    else
      if bg
        'background-color: #'+color+';'
      else
        'color: #'+color+';'
      end
    end
  end

  protected
  def search_category_tree_for_color(category)
    if category.display_color.nil? || category.display_color.empty?  
      if category.parent.nil?
        nil
      else
        search_category_tree_for_color(category.parent)
      end
    else
      category.display_color
    end
  end

end
