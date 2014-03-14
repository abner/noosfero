class CommunityTrackPlugin::TrackListBlock < Block

  include CommunityTrackPlugin::StepHelper

  settings_items :limit, :type => :integer, :default => 3
  settings_items :more_another_page, :type => :boolean, :default => false
  settings_items :category_ids, :type => Array, :default => []
  settings_items :hidden_ids, :type => Array, :default => []
  settings_items :priority_ids, :type => Array, :default => []

  def hidden_ids(format="str")
    if format == "str"
      settings[:hidden_ids].join(",")
    else
      settings[:hidden_ids]
    end
  end

  def hidden_ids=(ids)
    settings[:hidden_ids] = ids.split(",").uniq.map{|item| item.to_i unless item.to_i.zero?}.compact
  end

  def priority_ids(format="str")
    if format == "str"
      settings[:priority_ids].join(",")
    else
      settings[:priority_ids]
    end
  end

  def priority_ids=(ids)
    settings[:priority_ids] = ids.split(",").uniq.map{|item| item.to_i unless item.to_i.zero?}.compact
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

    priority_tracks = []
    hidden_tracks = []

    if !priority_ids.empty?
      priority_tracks = owner.articles.where(:type => 'CommunityTrackPlugin::Track', :id => priority_ids("ary"))
    end

    no_priority_tracks = owner.articles.where(:type => 'CommunityTrackPlugin::Track').order('hits DESC')

    if !category_ids.empty?
      no_priority_tracks = no_priority_tracks.joins(:article_categorizations).where(:articles_categories => {:category_id => category_ids})
    end

    if !hidden_ids.empty?
      hidden_tracks = owner.articles.where(:type => 'CommunityTrackPlugin::Track', :id => hidden_ids("ary"))
    end

    others_tracks = no_priority_tracks - hidden_tracks
    tracks = priority_tracks + others_tracks

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
