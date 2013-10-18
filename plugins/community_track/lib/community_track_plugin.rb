class CommunityTrackPlugin < Noosfero::Plugin; end;

require_dependency 'community_track_plugin/step'

class CommunityTrackPlugin < Noosfero::Plugin

  def self.plugin_name
    'Community Track'
  end

  def self.plugin_description
    _("New kind of content for communities.")
  end

  def stylesheet?
    true
  end

  def content_types
    types = []
    parent_id = context.params[:parent_id] 
    types << CommunityTrackPlugin::Track if context.profile.community? && !parent_id
    parent = parent_id ? context.profile.articles.find(parent_id) : nil
    types << CommunityTrackPlugin::Step if parent.kind_of?(CommunityTrackPlugin::Track)
    types
  end

  def self.extra_blocks
    { CommunityTrackPlugin::TrackListBlock => {:position => 1}, CommunityTrackPlugin::TrackCardListBlock => {} }
  end

end
