class PairwisePluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  def find_content(params)
    profile.articles.find(params[:id])
  end

  def prompt
    prompt_id = params[:prompt_id]
    @page = find_content(params)
    embeded = params.has_key?("embeded")
    source = params[:source]
    locals = {:embeded => embeded, :source => source, :prompt_id => prompt_id }
    if embeded
      render 'content_viewer/prompt', :layout => false, :locals => locals
    else
      render 'content_viewer/prompt', :locals => locals
    end
  end

  def choose
    @pairwise_content = find_content(params)
    @question = @pairwise_content.question_with_prompt_for_visitor(user_identifier)
    visitor = user_identifier
    vote = @pairwise_content.vote_to(@question, params[:direction], visitor)
    @pairwise_content.touch #altera o article pairwise_content para invalidar o cache da página de resultado
    if params.has_key?("embeded")
      next_prompt = vote['prompt']
      redirect_target = { :controller => :pairwise_plugin_profile,:action => 'prompt', :id => @pairwise_content.id,  :question_id => @question.id , :prompt_id => next_prompt["id"]}
      redirect_target.merge!(:embeded => 1) if params.has_key?("embeded")
      redirect_target.merge!(:source => params[:source]) if params.has_key?("source")
      redirect_to redirect_target
    else
      redirect_to @pairwise_content.url
    end
  end

  def result
    @embeded = params.has_key?("embeded")
    @page = @pairwise_content = find_content(params)
  end

 protected

   def is_external_vote
     params.has_key?("source") && !params[:source].empty?
   end

  def external_source
    params[:source]
  end

   def user_identifier
     if user.nil?
      is_external_vote ? "#{external_source}-#{request.session_options[:id]}" : "participa-#{request.session_options[:id]}"
     else
       user.identifier
     end
   end

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

