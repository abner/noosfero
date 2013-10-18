require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class EnvironmentDesignController; def rescue_action(e) raise e end; end

class EnvironmentDesignControllerTest < ActionController::TestCase

  def setup
    @controller = EnvironmentDesignController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    Environment.delete_all

    @environment = Environment.create(:name => 'testenv', :is_default => true)
    @environment.enabled_plugins = ['EnvironmentStatisticsPlugin']
    @environment.save!

    user = create_user('testinguser')
    @environment.add_admin(user.person)

    EnvironmentStatisticsBlock.delete_all
    @box1 = Box.create!(:owner => @environment)
    @environment.boxes = [@box1]

    @block = EnvironmentStatisticsBlock.new
    @block.box = @box1
    @block.save!

    login_as(user.login)
  end

  attr_accessor :block

  should 'be able to edit EnvironmentStatisticsBlock' do
    get :edit, :id => @block.id
    assert_tag :tag => 'input', :attributes => { :id => 'block_title' }
  end

  should 'be able to save EnvironmentStatisticsBlock' do
    get :edit, :id => @block.id
    post :save, :id => @block.id, :block => {:title => 'Statistics' }
    @block.reload
    assert_equal 'Statistics', @block.title
  end

  should 'be able to uncheck core stats' do
    @block.user_stat = true
    @block.community_stat = true
    @block.enterprise_stat = true
    @block.category_stat = true
    @block.tag_stat = true
    @block.comment_stat = true
    @block.hit_stat = true
    @block.save!
    get :edit, :id => @block.id
    post :save, :id => @block.id, :block => {:user_stat => '0', :community_stat => '0', :enterprise_stat => '0', 
      :category_stat => '0', :tag_stat => '0', :comment_stat => '0', :hit_stat => '0' }
    @block.reload
    any_checked = @block.is_visible?('user_stat') ||
                  @block.is_visible?('community_stat') ||
                  @block.is_visible?('enterprise_stat') ||
                  @block.is_visible?('category_stat') ||
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
    get :edit, :id => @block.id
    post :save, :id => @block.id, :block => {:user_stat => '1', :community_stat => '1', :enterprise_stat => '1', 
      :category_stat => '1', :tag_stat => '1', :comment_stat => '1', :hit_stat => '1' }
    @block.reload
    all_checked = @block.is_visible?('user_stat') &&
                  @block.is_visible?('community_stat') &&
                  @block.is_visible?('enterprise_stat') &&
                  @block.is_visible?('category_stat') &&
                  @block.is_visible?('tag_stat') &&
                  @block.is_visible?('comment_stat') &&
                  @block.is_visible?('hit_stat')
    assert all_checked
      
  end

  should 'be able to check template stats' do
    template = fast_create(Community, :name => 'Councils', :is_template => true, :environment_id => @environment.id)
    @block.templates_ids_stat = {template.id.to_s => 'false'}
    @block.save!
    get :edit, :id => @block.id
    post :save, :id => @block.id, :block => {:templates_ids_stat => {template.id.to_s => 'true'}}
    @block.reload

    assert @block.is_template_stat_active?(template.id)
  end
  
  should 'be able to uncheck template stats' do
    template = fast_create(Community, :name => 'Councils', :is_template => true, :environment_id => @environment.id)
    @block.templates_ids_stat = {template.id.to_s => 'true'}
    @block.save!
    get :edit, :id => @block.id
    post :save, :id => @block.id, :block => {:templates_ids_stat => {template.id.to_s => 'false'}}
    @block.reload

    assert_equal false, @block.is_template_stat_active?(template.id)
  end

  should 'input user counter be checked by default' do
    get :edit, :id => @block.id

    assert_tag :input, :attributes => {:id => 'block_user_stat', :checked => 'checked'}
  end
  
  should 'input community counter be checked by default' do
    get :edit, :id => @block.id

    assert_tag :input, :attributes => {:id => 'block_community_stat', :checked => 'checked'}
  end
  
  should 'not input enterprise counter be checked by default' do
    get :edit, :id => @block.id

    assert_tag :input, :attributes => {:id => 'block_enterprise_stat'}
    assert_no_tag :input, :attributes => {:id => 'block_enterprise_stat', :checked => 'checked'}
  end
  
    should 'not input category counter be checked by default' do
    get :edit, :id => @block.id

    assert_tag :input, :attributes => {:id => 'block_category_stat'}
    assert_no_tag :input, :attributes => {:id => 'block_category_stat', :checked => 'checked'}
  end
  
    should 'not input tag counter be checked by default' do
    get :edit, :id => @block.id

    assert_tag :input, :attributes => {:id => 'block_tag_stat'}
    assert_no_tag :input, :attributes => {:id => 'block_tag_stat', :checked => 'checked'}
  end
  
  should 'not input comment counter be checked by default' do
    get :edit, :id => @block.id

    assert_tag :input, :attributes => {:id => 'block_comment_stat'}
    assert_no_tag :input, :attributes => {:id => 'block_comment_stat', :checked => 'checked'}
  end
  
  should 'not input hit counter be checked by default' do
    get :edit, :id => @block.id

    assert_tag :input, :attributes => {:id => 'block_hit_stat'}
    assert_no_tag :input, :attributes => {:id => 'block_hit_stat', :checked => 'checked'}
  end  
end