class ApproveNewUploadedFile < ApproveNewArticle

  has_attachment :storage => :file_system, :max_size => UploadedFile.max_size

  validates_attachment :size => N_("{fn} of uploaded file was larger than the maximum size of %{size}").sub('%{size}', UploadedFile.max_size.to_humanreadable).fix_i18n

  postgresql_attachment_fu

  delegate :filename, :to => :article, :allow_nil => true
  delegate :size, :to => :article, :allow_nil => true
  delegate :content_type, :to => :article, :allow_nil => true

  def perform_with_attachment
    article.temp_path = full_filename
    perform_without_attachment
    #should delete the task attachment?
  end

  alias_method_chain :perform, :attachment

  def size=(s)
    article.size = s
    self.article_attributes = article.attributes.to_json
  end

  def title
    _("Create new uploaded file")
  end

end
