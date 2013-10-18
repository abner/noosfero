require File.dirname(__FILE__) + '/../test_helper'

class CommunityTrackPluginTest < ActiveSupport::TestCase

  def setup
    @plugin = CommunityTrackPlugin.new
    @profile = fast_create(Community)
    @params = {}
    @plugin.stubs(:context).returns(self)
  end
  
  attr_reader :profile, :params

  should 'return Track as a content type if profile is a community' do
    assert_includes @plugin.content_types, CommunityTrackPlugin::Track
  end

  should 'do not return Track as a content type if profile is not a community' do
    @profile = Organization.new
    assert_not_includes @plugin.content_types, CommunityTrackPlugin::Track
  end

  should 'do not return Track as a content type if there is a parent' do
    parent = fast_create(Blog, :profile_id => @profile.id)
    @params[:parent_id] = parent.id
    assert_not_includes @plugin.content_types, CommunityTrackPlugin::Track
  end

  should 'return Step as a content type if parent is a Track' do
    parent = fast_create(CommunityTrackPlugin::Track, :profile_id => @profile.id)
    @params[:parent_id] = parent.id
    assert_includes @plugin.content_types, CommunityTrackPlugin::Step
  end

  should 'do not return Step as a content type if parent is not a Track' do
    parent = fast_create(Blog, :profile_id => @profile.id)
    @params[:parent_id] = parent.id
    assert_not_includes @plugin.content_types, CommunityTrackPlugin::Step
  end
  
  should 'return track card as an extra block' do
    assert_includes CommunityTrackPlugin.extra_blocks, CommunityTrackPlugin::TrackListBlock
  end

end
