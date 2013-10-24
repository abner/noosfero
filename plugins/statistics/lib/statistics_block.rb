class StatisticsBlock < Block

  settings_items :community_stat, :default => false 
  settings_items :user_stat, :default => true
  settings_items :enterprise_stat, :default => false
  settings_items :category_stat, :default => false
  settings_items :tag_stat, :default => true
  settings_items :comment_stat, :default => true 
  settings_items :hit_stat, :default => true 
  settings_items :templates_ids_stat, Hash, :default => {}
  
  USER_COUNTERS = [:community_stat, :user_stat, :enterprise_stat, :tag_stat, :comment_stat, :hit_stat]
  COMMUNITY_COUNTERS = [:user_stat, :tag_stat, :comment_stat, :hit_stat]
  ENTERPRISE_COUNTERS = [:user_stat, :tag_stat, :comment_stat, :hit_stat]

  attr_reader :users
  attr_reader :enterprises
  attr_reader :communities
  attr_reader :categories
  attr_reader :tags
  attr_reader :comments
  attr_reader :hits

  def self.description
    _('Stastistics')
  end

  def default_title
    _('Statistics for %s') % owner.name
  end

  def is_visible? stat
    value = self.send(stat)
    value == '1' || value == true
  end

  def is_valid? stat
    if owner.kind_of?(Environment)
      true
    elsif owner.kind_of?(Person)
      USER_COUNTERS.include?(stat)
    elsif owner.kind_of?(Community)
      COMMUNITY_COUNTERS.include?(stat)
    elsif owner.kind_of?(Enterprise)
      ENTERPRISE_COUNTERS.include?(stat)
    end
    
  end
  
  def help
    _('This block presents some statistics about your context.')
  end

  def timeout
    60.minutes
  end

  def environment
    if owner.kind_of?(Environment) 
      owner
    elsif owner.kind_of?(Profile)
      owner.environment
    else
      nil
    end
  end

  def templates
    Community.templates(environment)
  end
  
  def is_template_stat_active? template_id
    self.templates_ids_stat[template_id.to_s].to_s == 'true'
  end

  def template_stat_count(template_id)
    owner.communities.visible.count(:conditions => {:template_id => template_id})
  end

  def users
    if owner.kind_of?(Environment)
      owner.people.visible.count
    elsif owner.kind_of?(Organization)
      owner.members.visible.count
    elsif owner.kind_of?(Person)
      owner.friends.visible.count
    else
      0
    end
  end

  def enterprises
    if owner.kind_of?(Environment) || owner.kind_of?(Person)
      owner.enterprises.visible.count
    else
      0
    end
  end

  def communities
    if owner.kind_of?(Environment) || owner.kind_of?(Person)
      owner.communities.visible.count
    else
      0
    end
  end

  def categories
    if owner.kind_of?(Environment) then
      owner.categories.count
    else
      0
    end
  end

  def tags
    if owner.kind_of?(Environment) then
      owner.tag_counts.count
    elsif owner.kind_of?(Profile) then
      owner.article_tags.count
    else
      0
    end
  end

  def comments
    if owner.kind_of?(Environment) then
      owner.profiles.joins(:articles).sum(:comments_count)
    elsif owner.kind_of?(Profile) then
      owner.articles.sum(:comments_count)
    else
      0
    end
  end

  def hits
    if owner.kind_of?(Environment) then
      owner.profiles.joins(:articles).sum(:hits)
    elsif owner.kind_of?(Profile) then
      owner.articles.sum(:hits)
    else
      0
    end
  end

  def content(args={})
    block = self

    lambda do
      render :file => 'statistics_block', :locals => { :block => block }
    end
  end

end
