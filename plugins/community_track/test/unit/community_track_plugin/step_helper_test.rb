require File.dirname(__FILE__) + '/../../test_helper'

class StepHelperTest < ActiveSupport::TestCase
  
  include CommunityTrackPlugin::Helpers::StepHelper

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

end
