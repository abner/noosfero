module PairwisePlugin::Helpers::ViewerHelper

  def choose_left_link(pairwise_content, question, prompt)
     link_to prompt.left_choice_text,  :controller => 'pairwise_plugin_profile', 
          :action => 'choose', :id => pairwise_content.id,:question_id => question.id , :prompt_id => prompt.id,
          :choice_id => prompt.left_choice_id , :direction => 'left'
  end
  
  def choose_right_link(pairwise_content, question, prompt)
    link_to prompt.right_choice_text,  :controller => 'pairwise_plugin_profile', 
          :action => 'choose', :id => pairwise_content.id,  :question_id => question.id , :prompt_id => prompt.id,
          :choice_id => prompt.right_choice_id , :direction => 'right' 
  end

  def pairwise_edit_link(label, pairwise_content)
    link_to label, myprofile_path(:controller => :cms, :action => :edit, :id => pairwise_content.id)
  end

  def pairwise_result_link(label, pairwise_content)
    link_to  label, pairwise_content.result_url
  end

end