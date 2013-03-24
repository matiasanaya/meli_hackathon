class Item < ActiveRecord::Base
  attr_accessible :has_stock, :meli_id, :user_id, :meli_stock, :meli_title, :stock_tracked, :sold_quantity, :real_stock
  
  belongs_to :user
  
  def has_sales
    (@sold_quantity>0)
  end
  
  def add_image_to_description!(user)
    it= JSON.parse(user.get("/items/#{@meli_id}/descriptions").body)
    description = JSON.parse(user.get("/items/#{@meli_id}/descriptions/#{it.first['id']}").body)['text']

    description = description + 
     "<p><img src=\"http://localhost:3000/items/#{@id}/photo.jpg\" alt=\"Informacion actualizada de stock\" height=\"480\" width=\"640\" data-src-original=\"http://localhost:3000/items/#{@id}/photo.jpg\"></p>"
    user.post_json("/items/#{@mercado_id}/descriptions",{:text=> description})
    
    @stock_tracked = true
  end
  
  def self.get_all_for_user!(user)
    items = JSON.parse(user.get("/users/#{user.meli_user_id}/items/search").body)['results']
    items.each do |it|
      the_item = Item.where(:meli_id => it).first
      item_info = JSON.parse(user.get("/items/#{it}").body)
      
      if !the_item       
        the_item = Item.new(:meli_id => it)
        item_info = JSON.parse(user.get("/items/#{it}").body)
        
        the_item.user_id = user.id
        the_item.meli_stock = item_info['available_quantity']
        the_item.real_stock = item_info['available_quantity']
        
        the_item.has_stock = ( the_item.meli_stock > 0 ) ? true : false
        the_item.sold_quantity = item_info['sold_quantity'] 
        the_item.meli_title = item_info['title']
        the_item.stock_tracked = false
        
        the_item.save
      else
        the_item.sold_quantity = item_info['sold_quantity'] 
        the_item.meli_stock = item_info['available_quantity']
        the_item.save
      end

    end
  end
  
  def update_from_meli!(user)
    item_info = JSON.parse(user.get("/items/#{@meli_id}").body)
    @sold_quantity = item_info['sold_quantity'] 
    @meli_stock = item_info['available_quantity']
    self.save
  end
end

