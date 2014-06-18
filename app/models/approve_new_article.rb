class ApproveNewArticle < Task
  validates_presence_of :requestor_id, :target_id, :article_attributes

  settings_items :article_attributes, :closing_statment

  def article
    return nil if self.article_attributes.nil?
    attributes = ActiveSupport::JSON.decode(self.article_attributes)
    @article ||= attributes['type'].constantize.new(attributes) unless self.article_attributes.nil?
  end

  def perform
    article.save!
  end

  def title
    _("Create new article")
  end

  def icon
    result = {:type => :defined_image, :src => '/images/icons-app/article-minor.png'}
    result.merge!({:url => article.url})
    result
  end

  def information
    if article.profile
      {:message => _('%{requestor} wants to create the article: %{article_name}.') % {:article_name => article.name} }
    else
      {:message => _("The profile was removed.")}
    end
  end

  def accept_details
    true
  end

  def reject_details
    true
  end

  def default_decision
    if article.profile
      'skip'
    else
      'reject'
    end
  end

  def accept_disabled?
    article.profile.blank?
  end

  def target_notification_description
    if article.profile
      _('%{requestor} wants to create the article: %{article}.') % {:requestor => requestor.name, :article => article.name}
    else
      _('%{requestor} wanted to create an article but the profile was removed.') % {:requestor => requestor.name}
    end
  end

  def target_notification_message
    target_notification_description + "\n\n" +
    _('You need to login on %{system} in order to approve or reject this article.') % { :system => environment.name }
  end

  def task_finished_message
    if !closing_statment.blank?
      _("Your request for create the article \"%{article}\" was approved. Here is the comment left by the admin who approved your article:\n\n%{comment} ") % {:article => article.name, :comment => closing_statment}
    else
      _('Your request for create the article "%{article}" was approved.') % {:article => article.name}
    end
  end

  def task_cancelled_message
    message = _('Your request for create the article "%{article}" was rejected.') % {:article => article.name}
    if !reject_explanation.blank?
      message += " " + _("Here is the reject explanation left by the administrator who rejected your article: \n\n%{reject_explanation}") % {:reject_explanation => reject_explanation}
    end
    message
  end

end
