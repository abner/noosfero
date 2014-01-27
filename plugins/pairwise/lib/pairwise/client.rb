class Pairwise::Client

  private_class_method :new
    
  ###
  # constructor for a pairwise client
  # local_identifier is the id of the question owner in the client app side
  def initialize(local_identifier)
    @local_identifier = local_identifier
  end

  # creates a new question in pairwise
  def create_question(name, ideas = [])
    ideas = ideas.join("\n") if ideas.is_a? Array
    q = Pairwise::Question.create({
                      :name => name,
                      :visitor_identifier => @local_identifier.to_s,
                      :local_identifier => @local_identifier.to_s,
                      :ideas => ideas
                    })
    q.it_should_autoactivate_ideas = true
    q.save
    q
  end

  def activate_question(question)
    question.active = true
    question.save
    question
  end

  # finds a question by a given id
  def find_question_by_id(question_id)
    question = Pairwise::Question.find question_id
    return question if question.local_identifier == @local_identifier.to_s
  end

  # returns all questions in pairwise owned by the local_identifier user
  def questions
    questions = Pairwise::Question.find(:all, :params => {:creator => @local_identifier})
    questions.select {|q| q if q.local_identifier == @local_identifier.to_s }
  end

  # get a question with a prompt, visitor_id (id of logged user) should be provided
  def question_with_prompt(question_id, visitor_id = "guest", prompt_id=nil)
    #raise Pairwise::Question.site
    question = Pairwise::Question.find_with_prompt(question_id, @local_identifier, visitor_id, prompt_id)
    return question if question.local_identifier == @local_identifier.to_s
  end

  # register votes in response to a prompt to a pairwise question
  def vote(prompt_id, question_id, direction, visitor_id="guest", appearance_lookup=nil)
    prompt = Pairwise::Prompt.find(prompt_id, :params => {:question_id => question_id})
    begin
      vote = prompt.post(:vote,
                         :question_id => question_id,
                         :vote => {
                           :direction => direction,
                           :visitor_identifier => visitor_id,
                           :appearance_lookup => appearance_lookup
                         },
                         :next_prompt => {
                           :with_appearance => true,
                           :with_visitor_stats => true,
                           :visitor_identifier => visitor_id
                         })
      Hash.from_xml(vote.body)
    rescue ActiveResource::ResourceInvalid => e
      raise Pairwise::Error.new(_("Vote not registered. Please check if all the necessary parameters were passed."))
    end
  end

  # skips a prompt
  def skip(prompt_id, question_id, visitor_id = "guest", appearance_lookup = nil)
     prompt = Pairwise::Prompt.find(prompt_id, :params => {:question_id => question_id})
     skip = prompt.post(:skip,
                       :question_id => question_id,
                       :skip => {
                         :visitor_identifier => visitor_id,
                         :appearance_lookup => appearance_lookup
                       },
                       :next_prompt => {
                         :with_appearance => true,
                         :with_visitor_stats => true,
                         :visitor_identifier => visitor_id
                       })

  end
  
  def pairwise_config
    options = environment.settings[:pairwise_plugin]
     [:api_host, :username, :password].each do |key|
        if options.keys.include?(key.to_s)
          Pairwise::ResourceSettings[key] = options[key.to_s]
        end
      end   
    
  end


  def self.build(local_identifier, settings)
    [Pairwise::Question, Pairwise::Prompt, Pairwise::Choice].each do | klas |
      if([Pairwise::Prompt, Pairwise::Choice].include?(klas))
        klas.site = settings["api_host"] +  "questions/:question_id/" 
      else
        klas.site = settings["api_host"]
      end      
      klas.user =  settings["username"]
      klas.password = settings["password"]
    end
    new local_identifier
  end
end