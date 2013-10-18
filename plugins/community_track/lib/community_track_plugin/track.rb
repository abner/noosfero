class CommunityTrackPlugin::Track < Folder
  
  settings_items :goals, :type => :string
  settings_items :expected_results, :type => :string

  def self.short_description
    _("Track")
  end

  def self.description
    _('Defines a track.')
  end

  def steps
    #XXX article default order is name (acts_as_filesystem) -> should use reorder (rails3)
    steps_unsorted.sort_by(&:position)
  end
  
  def steps_unsorted
    children.where(:type => 'CommunityTrackPlugin::Step')
  end

  def accept_comments?
    false
  end

  def comments_count
    steps_unsorted.joins(:children => :comments).count
  end

  #FIXME make this test
  def first_paragraph
    paragraphs = Hpricot(body).search('p')
    paragraphs.empty? ? '' : paragraphs.first.to_html
  end

  def category_name
    category = categories.first
    category ? category.name : ''
  end
  
  def to_html(options = {})
    track = self
    lambda do
      render :file => 'content_viewer/track.rhtml', :locals => {:track => track}
    end
  end

end
