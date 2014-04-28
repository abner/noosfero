class CommunityTrackPlugin::TrackListBlock < Block

  include CommunityTrackPlugin::StepHelper

  settings_items :limit, :type => :integer, :default => 3
  settings_items :more_another_page, :type => :boolean, :default => false
  settings_items :category_ids, :type => Array, :default => []
  settings_items :hidden_ids, :type => String, :default => ""
  settings_items :priority_ids, :type => String, :default => ""

  validate :limit_greater_than_zero

  def limit_greater_than_zero
    errors.add_to_base(N_('Limit must be greater than zero')) unless limit > 0
  end

  def hidden_ids=(ids)
    settings[:hidden_ids] = ids
  end

  def array_hidden_ids
    hidden_ids.split(",").uniq.map{|item| item.to_i unless item.to_i.zero?}.compact
  end

  def priority_ids=(ids)
    settings[:priority_ids] = ids
  end

  def array_priority_ids
    priority_ids.split(",").uniq.map{|item| item.to_i unless item.to_i.zero?}.compact
  end

  def self.description
    _('Track List')
  end

  def help
    _('This block displays a list of most relevant tracks.')
  end

  def track_partial
    'track'
  end

  def tracks(page=1, per_page=limit)
    all_tracks.paginate(:per_page => per_page, :page => page)
  end

  def count_tracks
    all_tracks.count
  end

  def accept_category?(cat)
    true #accept all?
  end

  def category_ids=(ids)
    settings[:category_ids] = ids.uniq.map{|item| item.to_i unless item.to_i.zero?}.compact
  end

  def categories
    Category.find(category_ids)
  end

  def all_tracks

    no_priority_tracks = owner.articles.where(:type => 'CommunityTrackPlugin::Track', :published => true).order('hits DESC')
    priority_tracks = owner.articles.where(:type => 'CommunityTrackPlugin::Track', :published => true, :id => array_priority_ids).order('hits DESC')
    hidden_tracks = owner.articles.where(:type => 'CommunityTrackPlugin::Track', :published => true, :id => array_hidden_ids)

    if !category_ids.empty?
      priority_tracks = priority_tracks.joins(:article_categorizations).where(:articles_categories => {:category_id => category_ids}) unless !priority_tracks.empty?
      no_priority_tracks = no_priority_tracks.joins(:article_categorizations).where(:articles_categories => {:category_id => category_ids})
    end

    tracks = (priority_tracks + (no_priority_tracks - hidden_tracks)).uniq

  end

  def content(args={})
    block = self
    lambda do
      render :file => 'blocks/track_list.rhtml', :locals => {:block => block}
    end
  end

  def has_page?(page, per_page=limit)
    return (page-1) * per_page < count_tracks
  end

  def footer
    block = self
    return nil if !has_page?(2)
    lambda do
      render :partial => 'blocks/track_list_more', :locals => {:block => block, :page => 2, :per_page => block.limit}
    end
  end

  def self.expire_on
    { :profile => [:article, :category], :environment => [:article, :category] }
  end

end
