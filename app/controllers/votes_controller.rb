class VotesController < ApplicationController
    include SessionsHelper
    include ApplicationHelper
    before_action :set_vote, only: [:show, :edit, :update, :destroy]
    before_action :set_vote, only: [:show, :edit, :update, :destroy, :show_api]
    before_action :authenticate, only: [:create_api]
  
    # GET /votes
    # GET /votes.json
  @@ -70,6 +71,20 @@ def destroy
      end
    end
  
    def create_api
      @vote = Vote.new({contribution_id: params['contribution_id']})
      @vote.user_id = @api_user.id
      if @vote.save
        render :show_api, id: @vote.id
      else
        render json: @vote.errors, status: :bad_request
      end
    end
  
    def show_api
      render json: @vote, status: :ok
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote