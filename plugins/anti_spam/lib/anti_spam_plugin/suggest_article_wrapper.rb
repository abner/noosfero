class AntiSpamPlugin::SuggestArticleWrapper < AntiSpamPlugin::Wrapper
  rakismet_attrs :author => ':name',
                 :author_email => :email,
                 :user_ip => :ip_adress,
                 :content => :article_body

  def self.wraps?(object)
    object.kind_of?(SuggestArticle)
  end
end
