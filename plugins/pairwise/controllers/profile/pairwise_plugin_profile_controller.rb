class PairwisePluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  def find_content(params)
    profile.articles.find(params[:id])
  end

  def prompt
    prompt_id = params[:prompt_id]
    @pairwise_content = find_content(params)
    @question = @pairwise_content.question_with_prompt_for_visitor(user.id, prompt_id)
    @prompt = @question.prompt
  end

  def choose
    @pairwise_content = find_content(params)
    @question = @pairwise_content.question_with_prompt_for_visitor(user.id)
    visitor = user.nil? ? 'guest' : user.id
    vote = @pairwise_content.vote_to(@question, params[:direction], visitor)
    next_prompt = vote['prompt']
    redirect_to :controller => :pairwise_plugin_profile,:action => 'prompt', :id => @pairwise_content.id,  :question_id => @question.id , :prompt_id => next_prompt["id"]
  end

 protected

  def process_error_message message
    # if message =~ /undefined method `module' for nil:NilClass/
    #   "Kalibro did not return any result. Verify if the selected configuration is correct."
    # else
    #   message
    # end
    message
  end

 
  def redirect_to_error_page(message)
    message = URI.escape(CGI.escape(process_error_message(message)),'.')
    redirect_to "/profile/#{profile.identifier}/plugin/pairwise/error_page?message=#{message}"
  end


end