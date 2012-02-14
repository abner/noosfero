class MezuroPlugin < Noosfero::Plugin

  def self.plugin_name
    "Mezuro"
  end

  def self.plugin_description
    _("A metric analizer plugin.")
  end

  def content_types
    [MezuroPlugin::ConfigurationContent, MezuroPlugin::ProjectContent]
  end

  def stylesheet?
    true
  end

  def js_files
    ['javascripts/results.js', 'javascripts/toogle.js', 'javascripts/autoreload.js']
  end

end
