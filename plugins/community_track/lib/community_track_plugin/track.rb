class CommunityTrackPlugin::Track < Folder

  settings_items :goals, :type => :string
  settings_items :expected_results, :type => :string

  validate :validate_categories

  attr_accessible :goals, :expected_results

  @children_comments

  def comments_count
    if defined?(@comments_count)
      @comments_count
    else
      @comments_count = update_comments_count
    end
  end

  def validate_categories
    errors.add(:categories, _('should not be blank.')) if categories.empty? && pending_categorizations.blank?
  end

  def self.icon_name(article = nil)
    'community-track'
  end

  def self.short_description
    _("Track")
  end

  def self.description
    _('Defines a track.')
  end

  def steps
    #XXX article default order is name (acts_as_filesystem) -> should use reorder (rails3)
    steps_unsorted.sort_by(&:position).select{|s| !s.hidden}
  end

  def hidden_steps
    steps_unsorted.select{|s| s.hidden}
  end

  def reorder_steps(step_ids)
    transaction do
      step_ids.each_with_index do |step_id, i|
        step = steps_unsorted.find(step_id)
        step.update_attribute(:position, step.position = i + 1)
      end
    end
  end

  def steps_unsorted
    children.where(:type => 'CommunityTrackPlugin::Step')
  end

  def accept_comments?
    false
  end

  def update_comments_count
    @children_comments = 0
    sum_children_comments self
    @children_comments
  end

  def sum_children_comments node
    node.children.each do |c|
      @children_comments += c.comments_count
      sum_children_comments c
    end
  end

  def css_class_name
    "community-track-plugin-track"
  end

  def first_paragraph
    return '' if body.blank?
    paragraphs = Nokogiri::HTML.fragment(body).css('p')
    paragraphs.empty? ? '' : paragraphs.first.to_html
  end

  def category_name
    category = categories.first
    category ? (category.top_ancestor.nil? ? '' : category.top_ancestor.name) : ''
  end

  def to_html(options = {})
    track = self
    proc do
      render :file => 'content_viewer/track', :locals => {:track => track}
    end
  end

end
