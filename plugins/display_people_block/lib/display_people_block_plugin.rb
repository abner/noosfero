require_dependency File.dirname(__FILE__) + '/display_people_block'

class DisplayPeopleBlockPlugin < Noosfero::Plugin

  def self.plugin_name
    "Display People Block Plugin"
  end

  def self.plugin_description
    _("A plugin that adds a people block")
  end

  def self.extra_blocks
    {
      DisplayPeopleBlock => {}
    }
  end

  def self.has_admin_url?
    false
  end

  def self.stylesheet?
    false
  end

end
