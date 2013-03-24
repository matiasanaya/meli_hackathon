class FakesController < ApplicationController
	def test
		@item = Item.new(meli_stock: (rand(63) + 1), meli_title:'Lorem', stock_tracked: true, real_stock: 5)
		@item.save
		@item
	end
	def index
		@items = Item.all
	end
end