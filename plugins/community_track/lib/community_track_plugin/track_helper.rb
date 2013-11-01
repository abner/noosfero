module CommunityTrackPlugin::TrackHelper
  
  def category_class(track)
    'category_' + (track.categories.empty? ? 'not_defined' : track.categories.first.name.to_slug)
  end

end
