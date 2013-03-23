class TextQuery < ActiveRecord::Base
  attr_accessible :response, :text
  before_save :query

  def self.query
  	# TODO escape HTML
  	# http.ssl_version = :TLSv1
  	self.response = RestClient.get('https://api.mercadolibre.com/sites/MLA/search?q=ipod', {accept: :json}, {ssl_version: :TLSv1})
  end
end
