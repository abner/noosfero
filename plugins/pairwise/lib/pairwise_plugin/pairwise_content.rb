class PairwisePlugin::PairwiseContent < Article
  include ActionView::Helpers::TagHelper
  settings_items :pairwise_question_id, :pairwise_question_active

  before_save :send_question_to_service
  after_destroy :destroy_question_from_service

  def self.short_description
    'Pairwise question'
  end

  def self.description
    'Question managed by pairwise'
  end

  def to_html(options = {})
    lambda do
      render :file => 'content_viewer/show_question.rhtml'
    end
  end

  def pairwise_client
    @pairwise_client ||= PairwiseClient.build(profile.id, environment.settings[:pairwise_plugin])
    @pairwise_client
  end


  def question
    begin
      @question ||= pairwise_client.find_question_by_id(pairwise_question_id)
    rescue Exception => error
      errors.add_to_base(error.message)
    end
    @question
  end

  def question_with_prompt_for_visitor(visitor='guest', prompt_id=nil)
    pairwise_client.question_with_prompt(pairwise_question_id, visitor, prompt_id)
  end

  def description=(value)
    @description=value
  end
  
  def description
    begin
      @description ||= question.name
    rescue
      @description = ""
    end
    @description
  end

  def choices
    return '' if @choices.nil?
    if @choices.empty?
      begin
        @choices ||= question.get_choices.map {|q| q.data}
        @choices = @choices.join("\n")
      rescue
        @choices = ""
      end
    end
    @choices
  end

  def choices=(value)
    @choices = value
  end

  def vote_to(question, direction, visitor='guest')
    raise _("Excepted question not found") if question.nil?
    raise _("Excepted prompt not found") if question.prompt.nil?
    next_prompt = pairwise_client.vote(question.prompt.id, question.id, direction, visitor, question.appearance_id)
  end

  def activated?
    self.pairwise_question_active == true and question.active == false
  end

  def send_question_to_service
    if new_record?
      created_question = create_pairwise_question
      self.pairwise_question_id = created_question.id
    else
      @question = question
      @question.ideas = choices
      @question.name = name
      
      pairwise_client.activate(@question) if activated?
      begin
        @question.save
      rescue Exception => e
         errors.add_to_base(N_('Error sending question to pairwise'))
         logger.error(e)
      end
    end
  end

  def destroy_question_from_service
    question.destroy unless question.nil?
  end


  def create_pairwise_question
    client = pairwise_client
    question = client.create_question(name, choices)
    question
  end

  def destroy_project_from_service
    project.destroy unless project.nil?
  end
end