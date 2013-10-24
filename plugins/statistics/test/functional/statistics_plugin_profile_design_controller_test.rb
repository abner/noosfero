require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class ProfileDesignController; def rescue_action(e) raise e end; end

class ProfileDesignControllerTest < ActionController::TestCase

  def setup
    @controller = ProfileDesignController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    Environment.delete_all

    @environment = Environment.create(:name => 'testenv', :is_default => true)
    @environment.enabled_plugins = ['StatisticsPlugin']
    @environment.save!

    user = create_user('testinguser')
    @person = user.person
    @environment.add_admin(@person)

    StatisticsBlock.delete_all
    @box1 = Box.create!(:owner => @person)
    @environment.boxes = [@box1]

    @block = StatisticsBlock.new
    @block.box = @box1
    @block.save!

    login_as(user.login)
  end

  attr_accessor :block

  should 'be able to edit StatisticsBlock' do
    get :edit, :id => @block.id, :profile => @person.identifier 
    assert_tag :tag => 'input', :attributes => { :id => 'block_title' }
  end

  should 'be able to save StatisticsBlock' do
    get :edit, :id => @block.id, :profile => @person.identifier
    post :save, :id => @block.id, :block => {:title => 'Statistics' }, :profile => @person.identifier
    @block.reload
    assert_equal 'Statistics', @block.title
  end

  should 'be able to uncheck core stats' do
    @block.user_stat = true
    @block.tag_stat = true
    @block.comment_stat = true
    @block.hit_stat = true
    @block.save!
    get :edit, :id => @block.id, :profile => @person.identifier
    post :save, :id => @block.id, :block => {:user_stat => '0', :tag_stat => '0', :comment_stat => '0', :hit_stat => '0' }, :profile => @person.identifier
    @block.reload
    any_checked = @block.is_visible?('user_stat') ||
                  @block.is_visible?('tag_stat') ||
                  @block.is_visible?('comment_stat') ||
                  @block.is_visible?('hit_stat')
    assert_equal false, any_checked
  end

  should 'be able to check core stats' do
    @block.user_stat = false
    @block.community_stat = false
    @block.enterprise_stat = false
    @block.category_stat = false
    @block.tag_stat = false
    @block.comment_stat = false
    @block.hit_stat = false
    @block.save!
    get :edit, :id => @block.id, :profile => @person.identifier
    post :save, :id => @block.id, :block => {:user_stat => '1',  
      :tag_stat => '1', :comment_stat => '1', :hit_stat => '1' }, :profile => @person.identifier
    @block.reload
    all_checked = @block.is_visible?('user_stat') &&
                  @block.is_visible?('tag_stat') &&
                  @block.is_visible?('comment_stat') &&
                  @block.is_visible?('hit_stat')
    assert all_checked
      
  end
  
end