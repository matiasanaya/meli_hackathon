require 'oauth2'
class User < ActiveRecord::Base
  attr_accessible :access_token, :email, :name, :password, :meli_user_id

 
  serialize :access_token, Hash
  
  OPTIONS = {
    raise_errors: true,
    parse: true,
    headers: {
      "Content-Type" => "application/json",
      "Accept"       => "application/json"
    }
  }
  
  def self.client_id
    "2671879237356460"
  end
  
  def self.api_url
    "https://api.mercadolibre.com"
  end
  def self.client_secret
    "5ECUtfrO7CYrkVB9jS9hwuaYs6HXYd8t"
  end
  
  
  def self.new_client
    OAuth2::Client.new(
      self.client_id,
      self.client_secret,
      site: self.api_url,
      authorize_url: "https://auth.mercadolibre.com/authorization?response_type=code&client_id=#{self.client_id}",
      token_url: "oauth/token",
    )
  end
  
  def get_access_token!(code)
    
      @client = User.new_client
      params = {
        code: code,
        grant_type: :authorization_code,
        client_id: User.client_id,
        client_secret: User.client_secret,
        redirect_uri: UsersController.callback_url(self.id),
      }

      url = @client.token_url(params)
      response = @client.request(:post, url, OPTIONS)
      
      @hash = response.parsed
      raise OAuth2::Error.new(response) unless @hash.is_a?(Hash) && @hash["access_token"]

      puts @client
      puts @hash
     #token = self.build_token(@client,@hash)
      self.access_token = @hash
      self.access_token['expiration_time'] = Time.now + @hash['expires_in'].seconds
 #   s = RestClient.post(
 #   "https://api.mercadolibre.com/oauth/token", 
 #  {:grant_type=>'authorization_code',:client_id => "2671879237356460", :client_secret=> "5ECUtfrO7CYrkVB9jS9hwuaYs6HXYd8",
 #   :code=> @code, :redirect_uri=>nil}.to_json, {:headers => {"Accept" => "application/json", "Content-Type" =>"application/json"} })

    # &redirect_uri=$APP_CALLBACK_URL
    
      self.save
  end
  
  def refresh_token!
    if self.access_token['expiration_time'] <= Time.now
      @client = User.new_client
      params = {
        grant_type: :refresh_token,
        client_id: User.client_id,
        client_secret: User.client_secret,
        refresh_token: self.access_token['refresh_token'],
      }

      url = @client.token_url(params)
      response = @client.request(:post, url, OPTIONS)
      
      @hash = response.parsed
      raise OAuth2::Error.new(response) unless @hash.is_a?(Hash) && @hash["access_token"]

#      token = build_token(@client, @hash)
      #self.write_attribute(:access_token,token)
      
      self.access_token = @hash
      self.access_token['expiration_time'] = Time.now + @hash['expires_in'].seconds
 #   s = RestClient.post(
 #   "https://api.mercadolibre.com/oauth/token", 
 #  {:grant_type=>'authorization_code',:client_id => "2671879237356460", :client_secret=> "5ECUtfrO7CYrkVB9jS9hwuaYs6HXYd8",
 #   :code=> @code, :redirect_uri=>nil}.to_json, {:headers => {"Accept" => "application/json", "Content-Type" =>"application/json"} })

    # &redirect_uri=$APP_CALLBACK_URL
    
      self.save
    end
  end
  
  def self.authenticate(name, password)
    u=find(:first, :conditions=>["name = ?", name])
    return nil if u.nil?
    puts u.attributes
    return u if u.password == password
    nil
  end
  
  def get(*args)
    refresh_token!
    build_token(User.new_client,self.access_token).get(*args).response
  end
  
  def get_meli_user_id!
    self.meli_user_id = JSON.parse(get('/users/me').body)['id']
    self.save
  end
  
  def post(*args)
    refresh_token!
    build_token(User.new_client,self.access_token).post(*args).response
  end
  def post_json(url,params)
    post(url,:headers => {"Content-Type"=>'application/json',"Accept"=>'application/json'},:body=> params.to_json)
  end
  def build_token(client, hash)
    OAuth2::AccessToken.from_hash(client, hash.merge(mode: :query, param_name: :access_token))
  end
  
end
