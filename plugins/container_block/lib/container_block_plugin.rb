class ContainerBlockPlugin < Noosfero::Plugin

  def self.plugin_name
    "Container Block Plugin"
  end

  def self.plugin_description
    _("A plugin that add a container block.")
  end
  
  def self.extra_blocks
    { ContainerBlock => {} }
  end

  def stylesheet?
    true
  end

end
