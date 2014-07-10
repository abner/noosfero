class AntiSpamPlugin::CommentWrapper < AntiSpamPlugin::Wrapper
  rakismet_attrs :author => :author_name,
                 :user_ip => :ip_address,
                 :content => :body

  def self.wraps?(object)
    object.kind_of?(Comment)
  end
end
