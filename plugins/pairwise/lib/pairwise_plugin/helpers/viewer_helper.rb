module PairwisePlugin::Helpers::ViewerHelper

  def pairwise_plugin_stylesheet
    plugin_style_sheet_path = PairwisePlugin.public_path('style.css')
    stylesheet_link_tag  plugin_style_sheet_path, :cache => "cache/plugins-#{Digest::MD5.hexdigest plugin_style_sheet_path.to_s}"
  end

  def choose_left_link(pairwise_content, question, prompt, embeded = false)
    link_target = {:controller => 'pairwise_plugin_profile',
          :action => 'choose', :id => pairwise_content.id,:question_id => question.id , :prompt_id => prompt.id,
          :choice_id => prompt.left_choice_id , :direction => 'left'}
     link_target.merge!(:embeded => 1) if embeded
     link_to prompt.left_choice_text,  link_target
  end

  def choose_right_link(pairwise_content, question, prompt, embeded = false)
    link_target = { :controller => 'pairwise_plugin_profile',
          :action => 'choose', :id => pairwise_content.id,  :question_id => question.id , :prompt_id => prompt.id,
          :choice_id => prompt.right_choice_id , :direction => 'right' }
    link_target.merge!(:embeded => 1) if embeded
    link_to prompt.right_choice_text,  link_target
  end

  def pairwise_edit_link(label, pairwise_content)
    link_target = myprofile_path(:controller => :cms, :action => :edit, :id => pairwise_content.id)
    link_to label, link_target
  end

  def pairwise_result_link(label, pairwise_content, embeded = false)
    link_target = pairwise_content.result_url
    link_target.merge!(:embeded => 1) if embeded
    link_to  label, link_target
  end

end

