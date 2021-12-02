class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  # GET /users or /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @users}
    end
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html {render :show}
      format.json {render json: @user}
    end
  end
  
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    key = request.headers[:HTTP_X_API_KEY]
    tmp = nil
    @us = nil
    if key
      tmp = User.where("token=?", key).first
      if tmp
        @us = tmp
      end
    else 
      @us = current_user
    end
    respond_to do |format|
      if @us.update(user_params)
        format.html { redirect_to @us, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @us }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @us.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :uid, :provider, :about)
    end
    
end

