require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < ActionController::TestCase

  def setup
    @controller = HomeController.new
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

  should 'display environment-statistics-block-data class in environment block edition' do
    get :index

    assert_tag :div, :attributes => {:class => 'environment-statistics-block-data'}
  end

  should 'display users class in environment-statistics-block-data block' do
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'users'} }
  end

  should 'not display users class in environment-statistics-block-data block' do
    @block.user_stat = false
    @block.save!
    get :index

    assert_no_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'users'} }
  end

  should 'display communities class in environment-statistics-block-data block' do
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'communities'} }
  end

  should 'not display communities class in environment-statistics-block-data block' do
    @block.community_stat = false
    @block.save!
    get :index

    assert_no_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'communities'} }
  end

  should 'display enterprises class in environment-statistics-block-data block' do
    @block.enterprise_stat = true
    @block.save!
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'enterprises'} }
  end

  should 'not display enterprises class in environment-statistics-block-data block' do
    get :index

    assert_no_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'enterprises'} }
  end

  should 'display categories class in environment-statistics-block-data block' do
    @block.category_stat = true
    @block.save!
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'categories'} }
  end

  should 'not display categories class in environment-statistics-block-data block' do
    get :index

    assert_no_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'categories'} }
  end

  should 'display tags class in environment-statistics-block-data block' do
    @block.tag_stat = true
    @block.save!
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'tags'} }
  end

  should 'not display tags class in environment-statistics-block-data block' do
    get :index

    assert_no_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'tags'} }
  end

  should 'display comments class in environment-statistics-block-data block' do
    @block.comment_stat = true
    @block.save!
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'comments'} }
  end

  should 'not display comments class in environment-statistics-block-data block' do
    get :index

    assert_no_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'comments'} }
  end
  
  should 'display hits class in environment-statistics-block-data block' do
    @block.hit_stat = true
    @block.save!
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'hits'} }
  end

  should 'not display hits class in environment-statistics-block-data block' do
    get :index

    assert_no_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'hits'} }
  end
  
  should 'display template name in class in environment-statistics-block-data block' do
    template = fast_create(Community, :name => 'Councils', :is_template => true, :environment_id => @environment.id)
    @block.templates_ids_stat = {template.id.to_s => 'true'}
    @block.save!
    get :index

    assert_tag :tag => 'div', :attributes => {:class => 'environment-statistics-block-data'}, :descendant => { :tag => 'li', :attributes => {:class => 'councils'} }
  end
end