class Pairwise::Choice < ActiveResource::Base
  extend Pairwise::Resource
  self.element_name = "choice"
    # extend Resource
    # self.site = self.site + "questions/:question_id/"
    #attr_accessor :data, :id, :active, :creator_id, :question_id
end