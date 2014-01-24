class PairwisePrompt < ActiveResource::Base
  extend PairwiseResource
  self.element_name = "prompt"
  # extend Resource
  # self.site  = self.site + "questions/:question_id/"
  #attr_accessor :name, :question_text, :question_ideas
end
