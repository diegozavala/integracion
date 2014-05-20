class ApiUsersController < ApplicationController
  before_action :set_api_user, only: [:show, :edit, :update, :destroy]

  # GET /api_users
  # GET /api_users.json
  def index
    @api_users = ApiUser.all
  end

  # GET /api_users/1
  # GET /api_users/1.json
  def show
  end

  # GET /api_users/new
  def new
    @api_user = ApiUser.new
  end

  # GET /api_users/1/edit
  def edit
  end

  # POST /api_users
  # POST /api_users.json
  def create
    @api_user = ApiUser.new(api_user_params)

    respond_to do |format|
      if @api_user.save
        format.html { redirect_to @api_user, notice: 'Api user was successfully created.' }
        format.json { render action: 'show', status: :created, location: @api_user }
      else
        format.html { render action: 'new' }
        format.json { render json: @api_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_users/1
  # PATCH/PUT /api_users/1.json
  def update
    respond_to do |format|
      if @api_user.update(api_user_params)
        format.html { redirect_to @api_user, notice: 'Api user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @api_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_users/1
  # DELETE /api_users/1.json
  def destroy
    @api_user.destroy
    respond_to do |format|
      format.html { redirect_to api_users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_user
      @api_user = ApiUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_user_params
      params.require(:api_user).permit(:name, :password)
    end
end
