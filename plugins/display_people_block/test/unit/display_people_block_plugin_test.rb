require File.dirname(__FILE__) + '/../test_helper'

class DisplayPeopleBlockPluginTest < ActiveSupport::TestCase

  should "return DisplayPeopleBlock in extra_blocks class method" do
    assert DisplayPeopleBlockPlugin.extra_blocks.keys.include?(DisplayPeopleBlock)
  end

  should "return false for class method has_admin_url?" do
    assert !DisplayPeopleBlockPlugin.has_admin_url?
  end

  should "return false for class method stylesheet?" do
    assert DisplayPeopleBlockPlugin.new.stylesheet?
  end

end
