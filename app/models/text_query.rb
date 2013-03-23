class TextQuery < ActiveRecord::Base
  attr_accessible :text, :response

  def query
  	#ANDA CON HTTP
  	base = 'https://api.mercadolibre.com/sites/MLA/search?q='
  	uri = URI.parse "#{base}#{CGI.escape(text)}"
  	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	http.ssl_version = :TLSv1	
	response = nil
	http.start { |agent| response = agent.get("#{uri.path}?q=#{CGI.escape(self.text)}&limit=1000") }
	json = JSON.parse(response.body)
  end

  def self.debug
  	puts self.last.query
  end

  def chart
  	prices = []
  	response = self.query
  	puts "!!!!!!#{response['results'].count}"
  	response['results'].each do |r|
  		prices << r['price'].to_i
  	end
  	number_of_bins = 25
  	price_dif = ((prices.max - prices.min) / number_of_bins).to_i
  	grouped = prices.group_by { |x| x / price_dif }
	min, max = grouped.keys.minmax
	bin = Hash[min.upto(max).map { |n| [(price_dif*n+price_dif/2).to_i, grouped[n] || []] }]
	amounts = []
	avg_prices = []
	bin.each do |key, array_of_prices|
		# avg_price = (array_of_prices.inject{ |sum, el| sum + el }.to_f / array_of_prices.size)
		# avg_prices << avg_price.round if avg_price > 0
		avg_prices << key #unless avg_price > 0
		amounts << array_of_prices.count
	end
	puts "Amounts: #{amounts}, Prices: #{avg_prices}"

  	chart = LazyHighCharts::HighChart.new('graph') do |f|
	    f.options[:chart][:backgroundColor] = '#fff'
	    f.options[:yAxis][:gridLineColor] = '#e9e9e9'
	    f.options[:yAxis][:categories] = ['Amount']
	    f.options[:xAxis][:categories] = avg_prices
	    f.series(:type=> 'line',:name=> "#{self.text}",:data => amounts)
	end
	return {chart: chart, prices: prices, avg_prices: avg_prices, amounts: amounts}
  end
end
