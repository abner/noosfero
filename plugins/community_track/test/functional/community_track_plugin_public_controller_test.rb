require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../controllers/public/community_track_plugin_public_controller'

# Re-raise errors caught by the controller.
class CommunityTrackPluginPublicController; def rescue_action(e) raise e end; end

class CommunityTrackPluginPublicControllerTest < ActionController::TestCase

  def setup
    @community = fast_create(Community)
    @track = CommunityTrackPlugin::Track.create!(:abstract => 'abstract', :body => 'body', :name => 'track', :profile => @community)

    box = fast_create(Box, :owner_id => @community.id, :owner_type => 'Community')
    @card_block = CommunityTrackPlugin::TrackCardListBlock.create!(:box => box)
    @block = CommunityTrackPlugin::TrackListBlock.create!(:box => box)
  end

  should 'display tracks for card block' do
    xhr :get, :view_tracks, :id => @card_block.id, :page => 1
    assert_match /track_list_#{@card_block.id}/, @response.body
  end

  should 'display tracks for list block' do
    xhr :get, :view_tracks, :id => @block.id, :page => 1
    assert_match /track_list_#{@block.id}/, @response.body
  end

  should 'display tracks with page size' do
    20.times do |i|
      track = CommunityTrackPlugin::Track.create!(:abstract => 'abstract', :body => 'body', :name => "track#{i}", :profile => @community)
    end
    xhr :get, :view_tracks, :id => @block.id, :page => 1, :per_page => 10
    assert_equal 10, @response.body.scan(/item/).size
  end

  should 'default page size is the block limit' do
    20.times do |i|
      track = CommunityTrackPlugin::Track.create!(:abstract => 'abstract', :body => 'body', :name => "track#{i}", :profile => @community)
    end
    xhr :get, :view_tracks, :id => @block.id, :page => 1
    assert_equal @block.limit, @response.body.scan(/item/).size
  end
  
  should 'display page for all tracks' do
    get :all_tracks, :id => @block.id
    assert_match /track_list_#{@block.id}/, @response.body
  end

  should 'show more link in all tracks if there is no more tracks to show' do
    10.times do |i|
      CommunityTrackPlugin::Track.create!(:abstract => 'abstract', :body => 'body', :name => "track#{i}", :profile => @community)
    end
    get :all_tracks, :id => @block.id
    assert assigns['show_more']
    assert_match /track_list_more_#{@block.id}/, @response.body
  end

  should 'do not show more link in all tracks if there is no more tracks to show' do
    CommunityTrackPlugin::Track.destroy_all
    get :all_tracks, :id => @block.id
    assert !assigns['show_more']
    assert_no_match /track_list_more_#{@block.id}/, @response.body
  end

end
