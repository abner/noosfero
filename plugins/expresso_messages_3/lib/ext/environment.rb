require_dependency 'environment'

class Environment

  settings_items :expresso_messages_plugin, :type => :hash, :default => {}

  validates_presence_of :expresso_messages_plugin_host, :if => lambda {|env| !env.expresso_messages_plugin.blank? }

  attr_accessible :expresso_messages_plugin_host, :expresso_messages_plugin_port, :expresso_messages_plugin_tls, :expresso_messages_plugin_onthefly_register, :expresso_messages_plugin_account, :expresso_messages_plugin_account_password, :expresso_messages_plugin_filter, :expresso_messages_plugin_base_dn, :expresso_messages_plugin_attr_mail, :expresso_messages_plugin_attr_login, :expresso_messages_plugin_attr_fullname

  def expresso_messages_plugin_attributes
    self.expresso_messages_plugin || {}
  end

  def expresso_messages_plugin_host= host
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['host'] = host
  end

  def expresso_messages_plugin_host
    self.expresso_messages_plugin['host']
  end

  def expresso_messages_plugin_port= port
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['port'] = port
  end

  def expresso_messages_plugin_port
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['port'] ||= 389
    self.expresso_messages_plugin['port']
  end

  def expresso_messages_plugin_account
    self.expresso_messages_plugin['account']
  end

  def expresso_messages_plugin_account= account
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['account'] = account
  end

  def expresso_messages_plugin_account_password
    self.expresso_messages_plugin['account_password']
  end

  def expresso_messages_plugin_account_password= password
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['account_password'] = password
  end

  def expresso_messages_plugin_base_dn
    self.expresso_messages_plugin['base_dn']
  end

  def expresso_messages_plugin_base_dn= base_dn
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['base_dn'] =  base_dn
  end

  def expresso_messages_plugin_attr_login
    self.expresso_messages_plugin['attr_login']
  end

  def expresso_messages_plugin_attr_login= login
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['attr_login'] = login
  end

  def expresso_messages_plugin_attr_fullname
    self.expresso_messages_plugin['attr_fullname']
  end

  def expresso_messages_plugin_attr_fullname= fullname
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['attr_fullname'] = fullname
  end

  def expresso_messages_plugin_attr_mail
    self.expresso_messages_plugin['attr_mail']
  end

  def expresso_messages_plugin_attr_mail= mail
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['attr_mail'] =  mail
  end

  def expresso_messages_plugin_onthefly_register
    self.expresso_messages_plugin['onthefly_register'].to_s == 'true'
  end

  def expresso_messages_plugin_onthefly_register= value
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['onthefly_register'] = (value.to_s == '1') ? true : false
  end

  def expresso_messages_plugin_filter
    self.expresso_messages_plugin['filter']
  end

  def expresso_messages_plugin_filter= filter
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['filter'] = filter
  end

  def expresso_messages_plugin_tls
    self.expresso_messages_plugin['tls'] ||= false
  end

  def expresso_messages_plugin_tls= value
    self.expresso_messages_plugin = {} if self.expresso_messages_plugin.blank?
    self.expresso_messages_plugin['tls'] = (value.to_s == '1') ? true : false
  end

end
