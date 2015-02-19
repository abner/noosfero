Paperclip.options[:command_path] = '/usr/bin/'
Paperclip::Attachment.default_options.merge!(
  :url => '/image_uploads/:id_partition/:basename_:style.:extension',
  :default_url => '/images/:style/missing.png',
  :styles => {
    :big => '150x150',
    :thumb => '100x100',
    :portrait => '64x64',
    :minor => '50x50>',
    :icon => '20x20!'
  }
)
