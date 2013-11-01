require File.dirname(__FILE__) + '/../../test_helper'

class TrackHelperTest < ActiveSupport::TestCase
  
  include CommunityTrackPlugin::TrackHelper

  def setup
    @track = CommunityTrackPlugin::Track.new
  end
  
  should 'return css class for track with category' do
    category = fast_create(Category, :name => 'education')
    @track.categories << category
    assert_equal 'category_education', category_class(@track)
  end

  should 'return default css class for a track without category' do
    assert_equal 'category_not_defined', category_class(@track)
  end
  
  should 'return css class for first category that the class belongs' do
    category1 = fast_create(Category, :name => 'education')
    @track.categories << category1
    category2 = fast_create(Category, :name => 'tech')
    @track.categories << category2
    assert_equal 'category_education', category_class(@track)
  end
  
  should 'return css class with category name properly formated' do
    category = fast_create(Category, :name => 'not defined')
    @track.categories << category
    assert_equal 'category_not-defined', category_class(@track)
  end

end
