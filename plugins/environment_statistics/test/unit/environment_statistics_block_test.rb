require File.dirname(__FILE__) + '/../test_helper'
class EnvironmentStatisticsBlockTest < ActiveSupport::TestCase
  
  ['community_stat', 'user_stat'].map do |stat|
    should "#{stat} be true by default" do
      b = EnvironmentStatisticsBlock.new
      assert b.is_visible?(stat)
    end
  end
  
  ['enterprise_stat', 'category_stat', 'tag_stat', 'comment_stat', 'hit_stat'].map do |stat|
    should "#{stat} be false by default" do
      b = EnvironmentStatisticsBlock.new
      assert !b.is_visible?(stat)
    end
  end

  should 'describe itself' do
    assert_not_equal EnvironmentStatisticsBlock.description, Block.description 
  end

  should 'is_visible? return true if setting is true' do
    b = EnvironmentStatisticsBlock.new
    b.community_stat = true
    assert b.is_visible?('community_stat')
  end

  should 'is_visible? return false if setting is false' do
    b = EnvironmentStatisticsBlock.new
    b.community_stat = false
    assert !b.is_visible?('community_stat')
  end
  
  should 'templates return the Community templates of the Environment' do
    b = EnvironmentStatisticsBlock.new
    e = fast_create(Environment)
    
    t1 = fast_create(Community, :is_template => true, :environment_id => e.id)
    t2 = fast_create(Community, :is_template => true, :environment_id => e.id)
    fast_create(Community, :is_template => false)
    
    box = mock
    b.expects(:box).returns(box)
    box.expects(:environment).returns(e)
    
    t = b.templates
    assert_equal [], [t1,t2] - t
    assert_equal [], t - [t1,t2]
  end
  
  should 'users return the amount of users of the Environment' do
    b = EnvironmentStatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Person, :environment_id => e.id)
    fast_create(Person, :environment_id => e.id)
    fast_create(Person, :visible => false, :environment_id => e.id)
    
    box = mock
    b.expects(:owner).returns(e)
    
    assert_equal 2, b.users
  end
  
  should 'communities return the amount of communities of the Environment' do
    b = EnvironmentStatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Community, :environment_id => e.id)
    fast_create(Community, :environment_id => e.id)
    fast_create(Community, :visible => false, :environment_id => e.id)
    
    box = mock
    b.expects(:owner).returns(e)
    
    assert_equal 2, b.communities
  end
  
  should 'enterprises return the amount of enterprises of the Environment' do
    b = EnvironmentStatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Enterprise, :environment_id => e.id)
    fast_create(Enterprise, :environment_id => e.id)
    fast_create(Enterprise, :visible => false, :environment_id => e.id)
    
    box = mock
    b.expects(:owner).returns(e)
    
    assert_equal 2, b.enterprises
  end

  should 'categories return the amount of categories of the Environment' do
    b = EnvironmentStatisticsBlock.new
    e = fast_create(Environment)
    
    fast_create(Category, :environment_id => e.id)
    fast_create(Category, :environment_id => e.id)
    
    box = mock
    b.expects(:owner).returns(e)
    
    assert_equal 2, b.categories
  end

  should 'tags return the amount of tags of the Environment' do
    b = EnvironmentStatisticsBlock.new
    e = fast_create(Environment)

    p1 = fast_create(Person, :environment_id => e.id)    
    a1 = fast_create(Article, :profile_id => p1.id)
    t1 = fast_create(Tag, :name => 'T1')
    t2 = fast_create(Tag, :name => 'T2')
    a1.tags << t1
    a1.tags << t2
    a2 = fast_create(Article, :profile_id => p1.id)
    t3 = fast_create(Tag, :name => 'T3')
    t4 = fast_create(Tag, :name => 'T4')
    a2.tags << t3
    a2.tags << t4
    
    box = mock
    b.expects(:owner).returns(e)
    
    assert_equal 4, b.tags
  end
  
  should 'is_template_stat_active? return true if setting is true' do
    b = EnvironmentStatisticsBlock.new
    b.templates_ids_stat = {'1' => 'true'}
    assert b.is_template_stat_active?(1)
  end

  should 'is_template_stat_active? return false if setting is false' do
    b = EnvironmentStatisticsBlock.new
    b.templates_ids_stat = {'1' => 'false'}
    assert !b.is_template_stat_active?(1)
  end

  should 'template_stat_count return the amount of communities of the Environment using a template' do
    b = EnvironmentStatisticsBlock.new
    e = fast_create(Environment)
    
    t1 = fast_create(Community, :is_template => true, :environment_id => e.id)
    t2 = fast_create(Community, :is_template => true, :environment_id => e.id)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t1.id, :visible => true)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t1.id, :visible => true)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t1.id, :visible => false)

    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t2.id, :visible => true)
    fast_create(Community, :is_template => false, :environment_id => e.id, :template_id => t2.id, :visible => false)
    
    box = mock
    b.expects(:owner).returns(e)
    
    assert_equal 2, b.template_stat_count(t1.id)
  end
end
