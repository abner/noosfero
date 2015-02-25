class Image < ActiveRecord::Base
  sanitize_filename

  attr_accessible :uploaded_data

  has_attached_file :uploaded_data
  validates_attachment_content_type :uploaded_data, :content_type => /\Aimage\/.*\Z/
end
