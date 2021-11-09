require "application_system_test_case"

class SubmissionAsksTest < ApplicationSystemTestCase
  setup do
    @submission_ask = submission_asks(:one)
  end

  test "visiting the index" do
    visit submission_asks_url
    assert_selector "h1", text: "Submission Asks"
  end

  test "creating a Submission ask" do
    visit submission_asks_url
    click_on "New Submission Ask"

    fill_in "Content", with: @submission_ask.content
    fill_in "Punts", with: @submission_ask.punts
    fill_in "Tittle", with: @submission_ask.tittle
    click_on "Create Submission ask"

    assert_text "Submission ask was successfully created"
    click_on "Back"
  end

  test "updating a Submission ask" do
    visit submission_asks_url
    click_on "Edit", match: :first

    fill_in "Content", with: @submission_ask.content
    fill_in "Punts", with: @submission_ask.punts
    fill_in "Tittle", with: @submission_ask.tittle
    click_on "Update Submission ask"

    assert_text "Submission ask was successfully updated"
    click_on "Back"
  end

  test "destroying a Submission ask" do
    visit submission_asks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Submission ask was successfully destroyed"
  end
end
