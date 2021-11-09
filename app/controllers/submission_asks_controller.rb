class SubmissionAsksController < ApplicationController
  before_action :set_submission_ask, only: %i[ show edit update destroy ]

  # GET /submission_asks or /submission_asks.json
  def index
    @submission_asks = SubmissionAsk.all
  end

  # GET /submission_asks/1 or /submission_asks/1.json
  def show
  end

  # GET /submission_asks/new
  def new
    @submission_ask = SubmissionAsk.new
  end

  # GET /submission_asks/1/edit
  def edit
  end

  # POST /submission_asks or /submission_asks.json
  def create
    @submission_ask = SubmissionAsk.new(submission_ask_params)

    respond_to do |format|
      if @submission_ask.save
        format.html { redirect_to @submission_ask, notice: "Submission ask was successfully created." }
        format.json { render :show, status: :created, location: @submission_ask }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @submission_ask.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submission_asks/1 or /submission_asks/1.json
  def update
    respond_to do |format|
      if @submission_ask.update(submission_ask_params)
        format.html { redirect_to @submission_ask, notice: "Submission ask was successfully updated." }
        format.json { render :show, status: :ok, location: @submission_ask }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission_ask.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submission_asks/1 or /submission_asks/1.json
  def destroy
    @submission_ask.destroy
    respond_to do |format|
      format.html { redirect_to submission_asks_url, notice: "Submission ask was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission_ask
      @submission_ask = SubmissionAsk.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submission_ask_params
      params.require(:submission_ask).permit(:tittle, :content, :punts)
    end
end
