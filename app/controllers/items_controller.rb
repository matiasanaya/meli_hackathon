class ItemsController < ApplicationController
  
  before_filter :login_required, :only => ['show','index','new','edit','create','destroy','add_image_to_description']
  
  # GET /items
  # GET /items.json
  def index
    Item.get_all_for_user!(User.find(session[:user]))

    @items = Item.where(:user_id => session[:user]).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @item.update_from_meli!(User.find(session[:user]))
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
      format.jpg { render :qrcode => "10.10.12.90:3000/items/#{@item.id.to_s}" }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def photo
    @item = Item.find(params[:id])
    
    respond_to do |format|
     
      if @item.has_stock
        abs_filepath = 'app/assets/images/has_stock.jpg'
      else
        abs_filepath = 'app/assets/images/has_no_stock.jpg'
      end
      
      format.jpg do
        File.open(abs_filepath, 'rb') do |f|
          send_data f.read, :type => "image/jpeg", :disposition => "inline"
        end
      end
    end
    
    
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
  
  def add_image_to_description
    @item = Item.find(params[:id])
    
    @item.add_image_to_description!(User.find(session[:user]))
    
    respond_to do |format|
      format.html {redirect_to @item}
      format.json {render json: @item}
    end
  end
  
  def modify_from_page
    @item = Item.find(params[:id])
    
    @item.modify_stuff!(User.find(session[:user]),params[:modify_action])
   
    
    respond_to do |format|
      format.html {redirect_to @item}
      format.json {render json: @item}
    end
  end
  
  def print_qr
    @item = Item.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def see_listing
    @item = Item.find(params[:id])
    respond_to do |format|
      format.html {redirect_to @item.get_listing_url(User.find(session[:user]))}
    end
  end
  
end
