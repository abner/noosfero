module CommunityTrackPlugin::Helpers::StepHelper

  def self.status_descriptions
    [_('Finished'), _('In progress'), _('Waiting')]
  end

  def self.status_classes
    ['step_finished', 'step_active', 'step_waiting']
  end

  def status_description(step)
    CommunityTrackPlugin::Helpers::StepHelper.status_descriptions[status_index(step)]
  end

  def status_class(step)
    CommunityTrackPlugin::Helpers::StepHelper.status_classes[status_index(step)]
  end

  protected

  def status_index(step)
    [step.finished?, step.active?, step.waiting?].find_index(true)
  end

end
