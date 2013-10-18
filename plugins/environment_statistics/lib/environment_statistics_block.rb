class EnvironmentStatisticsBlock < Block

  settings_items :community_stat, :default => true 
  settings_items :user_stat, :default => true
  settings_items :enterprise_stat, :default => false
  settings_items :category_stat, :default => false
  settings_items :tag_stat, :default => false
  settings_items :comment_stat, :default => false 
  settings_items :hit_stat, :default => false 
  settings_items :templates_ids_stat, Hash, :default => {}
  
  attr_reader :users
  attr_reader :enterprises
  attr_reader :communities
  attr_reader :categories
  attr_reader :tags
  attr_reader :comments
  attr_reader :hits

  def self.description
    _('Environment stastistics')
  end

  def default_title
    _('Statistics for %s') % owner.name
  end

  def is_visible? stat
    value = self.send(stat)
    value == '1' || value == true
  end

  def help
    _('This block presents some statistics about your environment.')
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
    owner.people.visible.count
  end

  def enterprises
    owner.enterprises.visible.count
  end

  def communities
    owner.communities.visible.count
  end

  def categories
    owner.categories.count
  end

  def tags
    owner.tags.count
  end

  def comments
    owner.profiles.joins(:articles).sum(:comments_count)
  end

  def hits
    owner.profiles.joins(:articles).sum(:hits)
  end

  def content(args={})
    block = self

    lambda do
      render :file => 'environment_statistics_block', :locals => { :block => block }
    end
  end

end
