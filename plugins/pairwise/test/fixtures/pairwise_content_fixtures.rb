class PairwiseContentFixtures

  def self.pairwise_content
    content = PairwisePlugin::PairwiseContent.new
    content.pairwise_question_id = 1
    content.name = "Question 1"
    content.choices = ["choice1,choice2"]
    content
  end

  def self.new_pairwise_content
    PairwisePlugin::PairwiseContent.new do |content|
      content.name = "New question content"
      content.published = true
    end
  end

  def self.pairwise_content_inactive
    content = self.pairwise_content
    content.published = false
    content
  end

  def self.pairwise_question 
    question = Pairwise::Question.new({
        :id => 1,
        :name => 'Question 1',
        :active => true,
        :description => 'Some description',
        :appearance_id =>  'abcdef'
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