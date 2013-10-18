require File.dirname(__FILE__) + '/../test_helper'

class EnvironmentStatisticsPluginTest < ActiveSupport::TestCase

  should "return EnvironmentStatisticsBlock in extra_mlocks class method" do
    assert  EnvironmentStatisticsPlugin.extra_blocks.keys.include?(EnvironmentStatisticsBlock)
  end

end
