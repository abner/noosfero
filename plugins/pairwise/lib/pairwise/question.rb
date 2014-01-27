class Pairwise::Question < ActiveResource::Base
  extend Pairwise::Resource

  self.element_name = "question"
  
  def get_choices
    Pairwise::Choice.find(:all, :params => {:question_id => self.id })
  end

  alias_method :choices, :get_choices

  def add_choice(text)
    Pairwise::Choice.create(:data => text, :question_id => self.id, :active => "true")
  end

  def self.find_with_prompt(id, creator_id, visitor_id, prompt_id=nil)
     #ap Question, :raw => true
     if prompt_id.nil?
      question = Pairwise::Question.find(id, 
                   :params => {
                                :creator_id => creator_id,
                                :with_prompt => true,
                                :with_appearance => true,
                                :visitor_identifier => visitor_id
                              })
      question.set_prompt(Pairwise::Prompt.find(question.picked_prompt_id, :params => {:question_id => id}))
    else
      question = Pairwise::Question.find(id, 
                  :params => {
                                :creator_id => creator_id,
                                :with_appearance => true,
                                :visitor_identifier => visitor_id
                              })
      question.set_prompt(Pairwise::Prompt.find(prompt_id, :params => {:question_id => id}))
    end
     question
  end

  def set_prompt(prompt_object)
    @prompt = prompt_object
  end

  def prompt
    @prompt
  end
end