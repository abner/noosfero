class AntiSpamPlugin::CommentWrapper < AntiSpamPlugin::Wrapper
  alias_attribute :author, :author_name
  alias_attribute :user_ip, :ip_address
  alias_attribute :content, :body

  rakismet_attrs :author => :author_name,
                 :user_ip => :ip_address,
                 :content => :body

  def self.wraps?(object)
    object.kind_of?(Comment)
  end
end
