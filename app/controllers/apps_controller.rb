class AppsController < ApplicationController
  before_filter :authenticate_client!, except: [:show, :index]
  before_filter :app_owner, only: [:edit, :update, :destroy]
  before_action :set_app, only: [:show, :edit, :update, :destroy] #[:index, :new, :create] 


  # GET /apps
  def index
    @apps = App.all
  end

  # GET /apps/1
  def show
  end

  # GET /apps/new
  def new
    @path = [current_client,App.new]
  end

  # GET /apps/1/edit
  def edit
    @path = @app
  end

  # POST /apps
  def create
   @app = App.new(app_params)
   current_client.apps.push(@app)
      if current_client.save
        redirect_to @app, notice: 'App was successfully created.' 
      else
        render action: 'new' 
      end
  end

  # PATCH/PUT /apps/1
  # PATCH/PUT /apps/1.json
  def update
      if @app.update(app_params)
        redirect_to @app, notice: 'App was successfully updated.' 
      else
        render action: 'edit' 
    end
  end

  # DELETE /apps/1
  def destroy
    @app.destroy
    redirect_to client_apps_url(current_client) 
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = current_client.apps.find(params[:id] || params[:app_id])
    end

    def app_owner
      set_app
      redirect_to(@app, notice: "You cant edit this") unless client_signed_in? && @app._parent == current_client
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.require(:app).permit(:name, :description)
    end

end