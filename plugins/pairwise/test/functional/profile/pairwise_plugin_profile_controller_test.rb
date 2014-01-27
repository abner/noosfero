require 'test_helper'

require "#{RAILS_ROOT}/plugins/pairwise/test/fixtures/pairwise_content_fixtures"

class PairwisePluginProfileControllerTest < ActionController::TestCase

  def pairwise_env_settings
    { "api_host" => "http://localhost:3030/",
      "username" => "abner.oliveira@serpro.gov.br",
      "password" => "serpro"
    }
  end

  def setup
    @environment = Environment.default
  
    @pairwise_client = Pairwise::Client.build(1, pairwise_env_settings)
    @controller = PairwisePluginProfileController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    
    @profile = fast_create(Community, :environment_id => @environment.id)

    @question = PairwiseContentFixtures.pairwise_question_with_prompt

    @user = create_user('testinguser').person

    @profile.add_admin(@user)

    @content =  PairwiseContentFixtures.pairwise_content
    @content.expects(:send_question_to_service).returns(nil)

    @profile.articles << @content
  end

  should 'get a first prompt' do
    login_as(@user.user.login)
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content)
    @content.expects(:question_with_prompt_for_visitor).with(@user.id, nil).returns(@question)
    get :prompt, 
                  :profile => @profile.identifier, 
                  :id => @content.id,
                  :question_id => @question.id         
    assert_not_nil  assigns(:prompt)
    assert_not_nil  assigns(:question)

    assert_equal @question.id, assigns(:question).id

    assert_match /#{@question.name}/, @response.body
    assert_match /#{@question.prompt.left_choice_text}/, @response.body
    assert_match /#{@question.prompt.right_choice_text}/, @response.body
  end

  should 'get a prompt by a prompt id' do
    login_as(@user.user.login)
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content)
    @content.expects(:question_with_prompt_for_visitor).with(@user.id, @question.prompt.id.to_s).returns(@question)
    get :prompt, 
                  :profile => @profile.identifier, 
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id         
    assert_not_nil  assigns(:prompt)
    assert_not_nil  assigns(:question)

    assert_equal @question.id, assigns(:question).id

    assert_match /#{@question.name}/, @response.body
    assert_match /#{@question.prompt.left_choice_text}/, @response.body
    assert_match /#{@question.prompt.right_choice_text}/, @response.body
  end

  should 'register a vote' do
    login_as(@user.user.login)
   
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content)
    @content.expects(:question_with_prompt_for_visitor).with(@user.id, nil).returns(@question)

    #next prompt will have id = 33
    next_prompt_id = 33
    
    vote = { 
            'prompt' => {
                        "id" => next_prompt_id,
                        "left_choice_id" => 3,
                        "left_choice_test" => "Option 3",
                        "right_choice_id" => 4,
                        "right_choice_text" => "Option 4"
              }
            }

    @content.expects(:vote_to).with(@question, 'left', @user.id).returns(vote)
    get :choose, 
                  :profile => @profile.identifier, 
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id,
                  :direction => 'left'
    assert_response :redirect
    assert_redirected_to :action => "prompt", :prompt_id => next_prompt_id
  end
end