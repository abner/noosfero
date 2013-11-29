enabled_plugins = Dir.glob(File.join(Rails.root, 'config', 'plugins', '*'))
enabled_plugins.select { |entry| File.directory?(entry) }.each do |dir|
  ActionController::Base.view_paths.unshift(File.join(dir, 'views'))
end

themes = Dir.glob(File.join(Rails.root, 'public', 'designs', 'themes', '*'))
themes.select { |entry| File.directory?(entry) }.each do |dir|
  ActionController::Base.view_paths.unshift(dir)
end
