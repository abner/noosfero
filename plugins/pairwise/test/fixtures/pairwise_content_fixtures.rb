class PairwiseContentFixtures

  def self.pairwise_content
    content = PairwisePlugin::PairwiseContent.new
    content.pairwise_question_active = true
    content.pairwise_question_id = 1
    content.name = "Question 1"
    content.choices = "choice1\nchoice2"
    content
  end

  def self.pairwise_content_inactive
    content = self.pairwise_content
    content.pairwise_question_active = false
    content
  end

  def self.pairwise_question 
    question = Pairwise::Question.new({
        :id => 1,
        :name => 'Question 1',
        :active => true,
        :description => 'Some description'
      })
  end

  def self.pairwise_prompt
    prompt = Pairwise::Prompt.new({
        :id => 1, 
        :question_id => 1, 
        :left_choice_text => 'Option 1', 
        :left_choice_id => 1,
        :right_choice_text => 'Option 2',
        :right_choice_id => 2
      })
  end

  def self.pairwise_question_with_prompt
    question = self.pairwise_question
    question.set_prompt self.pairwise_prompt
    question
  end
end