require "test_helper"

class SubmissionAsksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @submission_ask = submission_asks(:one)
  end

  test "should get index" do
    get submission_asks_url
    assert_response :success
  end

  test "should get new" do
    get new_submission_ask_url
    assert_response :success
  end

  test "should create submission_ask" do
    assert_difference('SubmissionAsk.count') do
      post submission_asks_url, params: { submission_ask: { content: @submission_ask.content, punts: @submission_ask.punts, tittle: @submission_ask.tittle } }
    end

    assert_redirected_to submission_ask_url(SubmissionAsk.last)
  end

  test "should show submission_ask" do
    get submission_ask_url(@submission_ask)
    assert_response :success
  end

  test "should get edit" do
    get edit_submission_ask_url(@submission_ask)
    assert_response :success
  end

  test "should update submission_ask" do
    patch submission_ask_url(@submission_ask), params: { submission_ask: { content: @submission_ask.content, punts: @submission_ask.punts, tittle: @submission_ask.tittle } }
    assert_redirected_to submission_ask_url(@submission_ask)
  end

  test "should destroy submission_ask" do
    assert_difference('SubmissionAsk.count', -1) do
      delete submission_ask_url(@submission_ask)
    end

    assert_redirected_to submission_asks_url
  end
end
