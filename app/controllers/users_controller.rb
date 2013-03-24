require 'oauth2'
class UsersController < ApplicationController
  
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:name], params[:password])
        flash[:message]  = "Bienvenido, " + params[:name] + '!'
        redirect_to_stored
      else
        flash[:warning] = "Login incorrecto"
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Desconectado.'
    redirect_to :action => 'login'
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to  authorize_url(@user.id)}
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def authorize_url(id)
    "https://auth.mercadolibre.com.ar/authorization?response_type=code&client_id=#{User.client_id}&redirect_uri=#{ callback_url(id) }"
  end
  def self.callback_url(id)
    #url_for(:controller=> 'users', :action=>'authorize', :id=>id)
    "http://localhost:3000/users/#{id}/authorize"
  end
  def callback_url(id)
    url_for(:controller=> 'users', :action=>'authorize', :id=>id)
  end
  # GET /users/1/authorize
  def authorize
    @user = User.find(params[:id])
    #https://api.mercadolibre.com
    @user.get_access_token!(params[:code])
    @user.get_meli_user_id!
  
    
    
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
    
  end
  
 
  
end
