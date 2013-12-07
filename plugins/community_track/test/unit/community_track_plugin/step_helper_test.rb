require File.dirname(__FILE__) + '/../../test_helper'

class StepHelperTest < ActiveSupport::TestCase

  include CommunityTrackPlugin::StepHelper

  def setup
    @step = CommunityTrackPlugin::Step.new
    @step.stubs(:active?).returns(false)
    @step.stubs(:finished?).returns(false)
    @step.stubs(:waiting?).returns(false)
  end

  should 'return active class when step is active' do
    @step.stubs(:active?).returns(true)
    assert_equal 'step_active', status_class(@step)
  end

  should 'return finished class when step is finished' do
    @step.stubs(:finished?).returns(true)
    assert_equal 'step_finished', status_class(@step)
  end

  should 'return waiting class when step is active' do
    @step.stubs(:waiting?).returns(true)
    assert_equal 'step_waiting', status_class(@step)
  end

  should 'return a description for status' do
    @step.stubs(:waiting?).returns(true)
    assert_equal _('Soon'), status_description(@step)
  end

  should 'return content without link if there is no tool in a step' do
    link = link_to_step_tool(@step) do
      "content"
    end
    assert_equal 'content', link
  end

  should 'return link to step tool if there is a tool' do
    profile = fast_create(Community)
    tool = fast_create(Article, :profile_id => profile.id)
    @step.stubs(:tool).returns(tool)
    expects(:link_to).with(tool.view_url, {}).once
    link = link_to_step_tool(@step) do
      "content"
    end
  end

end
