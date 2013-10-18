require File.dirname(__FILE__) + '/../../test_helper'

class TrackTest < ActiveSupport::TestCase

  def setup
    @explicit_view_paths = File.join(File.dirname(__FILE__) + '/../../../views')

    profile = fast_create(Community)
    @track = CommunityTrackPlugin::Track.create!(:profile => profile, :name => 'track')
    @step = CommunityTrackPlugin::Step.create!(:parent => @track, :start_date => Date.today, :end_date => Date.today, :name => 'step', :profile => profile)
    @tool = fast_create(Article, :parent_id => @step.id, :profile_id => profile.id)
  end

  should 'return comments count of children tools' do
    assert_equal 0, @track.comments_count
    comment = fast_create(Comment, :source_id => @tool.id)
    assert_equal 1, @track.comments_count
  end

  should 'return children steps' do
    assert_equal [@step], @track.steps_unsorted
  end

  should 'do not return other articles type at steps' do
    article = fast_create(Article, :parent_id => @track.id, :profile_id => @track.profile.id)
    assert_includes @track.children, article
    assert_equal [@step], @track.steps_unsorted
  end

  should 'return category name' do
    category = fast_create(Category, :name => 'category')
    @track.categories << category
    assert_equal 'category', @track.category_name
  end

  should 'return empty for category name if it has no category' do
    @track.categories.delete_all
    assert_equal '', @track.category_name
  end

  should 'return category name of first category' do
    category = fast_create(Category, :name => 'category')
    @track.categories << category
    category2 = fast_create(Category, :name => 'category2')
    @track.categories << category2
    assert_equal 'category', @track.category_name
  end

  should 'return steps with insert order' do
    @track.children.destroy_all
    step1 = CommunityTrackPlugin::Step.create!(:parent => @track, :start_date => Date.today, :end_date => Date.today, :name => "step1", :profile => @track.profile)
    step2 = CommunityTrackPlugin::Step.create!(:parent => @track, :start_date => Date.today, :end_date => Date.today, :name => "step2", :profile => @track.profile)
    step3 = CommunityTrackPlugin::Step.create!(:parent => @track, :start_date => Date.today, :end_date => Date.today, :name => "step3", :profile => @track.profile)
    assert_equal 1, step1.position
    assert_equal 2, step2.position
    assert_equal 3, step3.position
    assert_equal [step1, step2, step3], @track.steps
  end
  
  should 'return steps with order defined by position attribute' do
    @track.children.destroy_all
    step1 = CommunityTrackPlugin::Step.create!(:parent => @track, :start_date => Date.today, :end_date => Date.today, :name => "step1", :profile => @track.profile)
    step2 = CommunityTrackPlugin::Step.create!(:parent => @track, :start_date => Date.today, :end_date => Date.today, :name => "step2", :profile => @track.profile)
    step3 = CommunityTrackPlugin::Step.create!(:parent => @track, :start_date => Date.today, :end_date => Date.today, :name => "step3", :profile => @track.profile)
    step1.position = 3
    step1.save!
    step2.position = 1
    step2.save!
    step3.position = 2
    step3.save!
    assert_equal [step2, step3, step1], @track.steps
  end

  #FIXME
  should 'show new step button at generated html if user has permission for that' do
    #html = instance_eval(&@track.to_html)
  end

end
