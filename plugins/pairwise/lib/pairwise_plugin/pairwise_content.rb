class PairwisePlugin::PairwiseContent < Article
  include ActionView::Helpers::TagHelper
  settings_items :pairwise_question_id

  before_save :send_question_to_service
  after_destroy :call_destroy_in_pairwise

  validate_on_create :validate_choices

 def initialize(*args)
    super(*args)
    self.published = false
  end

   alias_method :original_view_url, :view_url

  def view_url
    #pairwise content points to prompt page by default
    profile.url.merge(
                      :controller => :pairwise_plugin_profile, 
                      :action => :prompt, 
                      :id => id)
  end

  def result_url
    url
  end

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
    @pairwise_client ||= Pairwise::Client.build(profile.id, environment.settings[:pairwise_plugin])
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
    #raise question.get_choices.inspect
    if @choices.nil?
      begin
        @choices ||= question.get_choices.map {|q| { q.id.to_s, q.data } }
        #@choices = @choices.join("\n")
      rescue
        @choices = []
      end
    end
    @choices ||= []
  end

  def choices=(value)
    @choices = value
  end

  def choices_saved
    @choices_saved
  end

  def choices_saved=value
    @choices_saved = value
  end

  def vote_to(question, direction, visitor='guest')
    raise _("Excepted question not found") if question.nil?
    raise _("Excepted prompt not found") if question.prompt.nil?
    next_prompt = pairwise_client.vote(question.prompt.id, question.id, direction, visitor, question.appearance_id)
  end

   def validate_choices
    errors.add_to_base(_("Choices empty")) if choices.nil?
    errors.add_to_base(_("Choices invalid format")) unless choices.is_a?(Array)
    errors.add_to_base(_("Choices invalid")) if choices.size == 0
    choices.each do | choice |
      if choice.empty?
        errors.add_to_base(_("Choice empty")) 
        break
      end
    end
  end

  def send_question_to_service
    if new_record?
      created_question = create_pairwise_question
      self.pairwise_question_id = created_question.id
    else
      begin
        #add new choices
        unless @choices.nil?
          @choices.each do |choice_text|
            pairwise_client.add_choice(pairwise_question_id, choice_text) unless choice_text.empty?
          end
        end
        #change old choices
        unless @choices_saved.nil?
          @choices_saved.each do |id,data|
            pairwise_client.update_choice(question, id, data)
          end
        end
        pairwise_client.update_question(pairwise_question_id, name)
      rescue Exception => e
        errors.add_to_base(N_("Error adding new choice to question. ") + N_(e.message))
        return false
      end
    end
  end

  def call_destroy_in_pairwise
    question.destroy unless question.nil?
  end

  def create_pairwise_question
    question = pairwise_client.create_question(name, choices)
    question
  end

end