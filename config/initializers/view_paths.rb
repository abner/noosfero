Noosfero::Plugin.all.each do |plugin|
  ActionController::Base.view_paths.unshift(plugin.constantize.view_path)
end

themes = Dir.glob(File.join(Rails.root, 'public', 'designs', 'themes', '*'))
themes += Dir.glob(File.join(Rails.root, 'public', 'user_themes', '*'))
themes.select { |entry| File.directory?(entry) }.each do |dir|
  ActionController::Base.view_paths.unshift(dir)
end
