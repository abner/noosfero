require_dependency 'environment'

class Environment
  settings_items :pairwise_plugin, :type => :hash, :default => {}

  validates_presence_of :pairwise_plugin_api_host, :if => lambda {|env| !env.pairwise_plugin.blank? }
  validates_presence_of :pairwise_plugin_username, :if => lambda {|env| !env.pairwise_plugin.blank? }
  validates_presence_of :pairwise_plugin_password, :if => lambda {|env| !env.pairwise_plugin.blank? }


  def pairwise_plugin_attributes
    self.settings[:pairwise_plugin] || {}
  end

  def pairwise_plugin_api_host= host
    self.pairwise_plugin_attributes = {} if self.pairwise_plugin_attributes.blank?
    self.pairwise_plugin_attributes['api_host'] = host
  end

  def pairwise_plugin_api_host
    self.pairwise_plugin_attributes['api_host']
  end

  def pairwise_plugin_username= username
    self.pairwise_plugin_attributes = {} if self.pairwise_plugin_attributes.blank?
    self.pairwise_plugin_attributes['username'] = username
  end


  def pairwise_plugin_username
    self.pairwise_plugin_attributes['username']
  end

  
def pairwise_plugin_password= password
    self.pairwise_plugin_attributes = {} if self.pairwise_plugin_attributes.blank?
    self.pairwise_plugin_attributes['password'] = password
  end


  def pairwise_plugin_password
    self.pairwise_plugin_attributes['password']
  end
end