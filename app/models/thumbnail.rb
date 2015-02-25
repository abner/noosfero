class Thumbnail < ActiveRecord::Base
  has_attachment :storage => :file_system,
    :content_type => :image, :max_size => 5.megabytes
  validates_as_attachment

  sanitize_filename

  attr_accessible :uploaded_data
end
