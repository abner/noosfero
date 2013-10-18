require_dependency File.dirname(__FILE__) + '/environment_statistics_block'

class EnvironmentStatisticsPlugin < Noosfero::Plugin

  def self.plugin_name
    "Environment Statistics Plugin"
  end

  def self.plugin_description
    _("A plugin that adds a block where you can see statistics of the environment.")
  end

  def self.extra_blocks
    {
      EnvironmentStatisticsBlock => {:type => Environment}
    }
  end

end
