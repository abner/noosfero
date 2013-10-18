class CommunityTrackPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')
  
  before_filter :edit_track

  def edit_track
    render_access_denied unless profile.articles.find(params[:track]).allow_edit?(user)
  end

  def save_order
    steps = params[:step_ids]
    track = profile.articles.find(params[:track])
    steps.each_with_index do |step_id, i|
      step = track.children.find(step_id)
      step.position = i + 1
      step.save!
    end
    redirect_to track.url
  end

end
