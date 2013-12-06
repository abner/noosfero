Noosfero::Plugin.all.each do |plugin|
  ActionController::Base.view_paths.unshift(plugin.constantize.view_path)
end
