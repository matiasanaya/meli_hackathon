class FakesController < ApplicationController
	def test
		@item = Item.new(meli_stock: (rand(63) + 1), meli_title:'Lorem ipsum fsdi ceowo csjo coscosko csoacs', stock_tracked: [true, false].sample, real_stock: 5)
		@item.save
		@item
	end
	def index
		@items = Item.all
	end
end