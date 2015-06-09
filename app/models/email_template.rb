class EmailTemplate < ActiveRecord::Base

  belongs_to :owner, :polymorphic => true

  attr_accessible :template_type, :subject, :body, :owner, :name

  def parsed_body(params)
    @parsed_body ||= parse(body, params)
  end

  def parsed_subject(params)
    @parsed_subject ||= parse(subject, params)
  end

  protected

  def parse(source, params)
    template = Liquid::Template.parse(source)
    template.render(HashWithIndifferentAccess.new(params))
  end

end
