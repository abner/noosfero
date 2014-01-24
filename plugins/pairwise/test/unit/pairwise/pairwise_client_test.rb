require "test_helper"

class PairwiseClientTest < ActiveSupport::TestCase
  def setup
    pairwise_env_settings = { "api_host" => "http://localhost:3030/",
      "username" => "abner.oliveira@serpro.gov.br",
      "password" => "serpro"
    }
    @client = PairwiseClient.build('1', pairwise_env_settings)
    @choices = "Choice 1\nChoice 2"
    @question = @client.create_question('Q1', @choices)
  end

  should 'create an new question in pairwise service' do
    assert_not_nil @question.id
  end

  should 'question be innactive when created' do
    assert_equal false, @question.active
  end

  should 'activate a question' do
    @client.activate_question(@question)
    assert_equal true, @client.find_question_by_id(@question.id).active
  end

  should 'retrieve question from service' do
    @question_retrieved = @client.find_question_by_id(@question.id)
    assert_not_nil @question_retrieved
    assert_equal @question.id, @question_retrieved.id
  end

  should 'retrieve question with values correct attributes values' do
    @question_retrieved = @client.find_question_by_id(@question.id)
    assert_equal "Q1", @question_retrieved.name
  end

  should 'retrieve question choices' do
    @question_retrieved = @client.find_question_by_id(@question.id)
    assert_not_nil @question_retrieved.choices
    @question_retrieved.choices.each do | choice |
      assert @choices.include?(choice.data), "Choice #{choice} not found in question retrieved"
    end
  end

  should 'register votes' do
    @question = @client.question_with_prompt(@question.id)
    assert_not_nil @question.prompt
    vote = @client.vote(@question.prompt.id, @question.id, 'left', 'guest-tester', @question.appearance_id)
    assert vote.is_a?(Hash)
    assert_not_nil vote["prompt"], "Next prompt hash expected"
    assert_not_nil vote["prompt"]["id"], "Next prompt id expected"
    assert_not_nil vote["prompt"]["question_id"], "question_id expected"
    assert_not_nil vote["prompt"]["appearance_id"], "appearance_id expected"
    assert_not_nil vote["prompt"]["left_choice_text"], "left_choice_text expected"
    assert_not_nil vote["prompt"]["right_choice_text"], "right_choice_text expected"
  end

  should 'not register votes when appearance_id is missing' do
    @question = @client.question_with_prompt(@question.id)
    assert_not_nil @question.prompt
    exception = assert_raises PairwiseError do
      @client.vote(@question.prompt.id, @question.id, 'left', 'guest-tester')
    end
    assert_equal "Vote not registered. Please check if all the necessary parameters were passed.", exception.message
  end
end
