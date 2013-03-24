class Item < ActiveRecord::Base
  attr_accessible :has_stock, :meli_id, :user_id, :meli_stock, :meli_title, :stock_tracked, :sold_quantity, :real_stock
  
  belongs_to :user
  
  def has_sales
    (@sold_quantity>0)
  end
  
  def add_image_to_description!(user)
    
    if !self.stock_tracked
       it = JSON.parse(user.get("/items/#{self.meli_id}").body)
       
       description = "<p><img src=\"http://localhost:3000/items/#{self.id.to_s}/photo.jpg\" alt=\"Informacion actualizada de stock\" height=\"480\" width=\"640\"></p>"
     
       
        
        if it['sold_quantity']>0
          user.post_json("/items/#{self.meli_id}/descriptions",{"text"=> description})
        else
          desc= JSON.parse(user.get("/items/#{self.meli_id}/descriptions").body).first
          desc["text"] = desc["text"] + description
          user.put_json("/items/#{self.meli_id}/descriptions/#{desc["id"]}",desc)
        end
        
        self.stock_tracked = true
        self.save
    end
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
    item_info = JSON.parse(user.get("/items/#{self.meli_id}").body)
    self.sold_quantity = item_info['sold_quantity'] 
    self.meli_stock = item_info['available_quantity']
    self.save
  end
  
  def modify_stuff!(user,act)
    case act
    when 'decrement_real_stock'
      if real_stock > 0
        self.real_stock -= 1
        if self.real_stock == 0
          self.has_stock = false
        end
      end
    when 'increment_real_stock'
      self.real_stock +=1
      self.has_stock = true
    when 'decrement_meli_stock'
      self.meli_stock -= 1
      item_info = {}
      item_info['available_quantity'] = self.meli_stock
      
      user.put_json("/items/#{self.meli_id}",item_info)
      
      
    when 'increment_meli_stock'
      self.meli_stock += 1
      item_info = {}
      item_info['available_quantity'] = self.meli_stock
      
      user.put_json("/items/#{self.meli_id}",item_info)
    when 'mark_no_stock'
      self.has_stock = false
    when 'mark_stock'
      self.has_stock = true
    end
    
    self.save
  end
end

