#!/usr/bin/env ruby

module Reevoo
  class Checkout
    attr_reader :items

    def initialize(pricing_rules)
      @items          = []
      @pricing_rules  = pricing_rules
    end

    def scan(item)
      @items << item
    end

    def total
      @pricing_rules.items = @items.dup
      items.inject(0.0){|acc, item| acc += item.price } - @pricing_rules.total_discount
    end
  end

  class PricingRules
    attr_accessor :items

    def initialize
      @rules = [:fruit_tea, :strawberries]
      @total_discount = 0.0
    end

    def total_discount
      @rules.each{|rule| self.send("apply_#{rule}_discount") }
      @total_discount
    end

  private
    def apply_fruit_tea_discount
      fruit_tea_count = items.count{|el| :fr1 == el.name }
      @total_discount += fruit_tea_count / 2 * fruit_tea_price
    end

    def apply_strawberries_discount
      strawberries_count = items.count{|el| :sr1 == el.name }
      @total_discount += strawberries_count * 0.50 if strawberries_count > 2
    end

    def fruit_tea_price
      sample_fruit = items.first{|el| :fr1 == el.name }
      sample_fruit and sample_fruit.price or 0.0
    end
  end

  class Item
    Detail = Struct.new(:name, :price, :description)
    @@items = {
      fr1: Detail.new(:fr1, 3.11,   'fruit tea'),
      sr1: Detail.new(:sr1, 5.00,   'Strawberries'),
      cf1: Detail.new(:cf1, 11.23,  'Coffee')
    }

    class NotFound < StandardError; end

    attr_reader :name, :description
    attr_accessor :price

    class << self
      def find(id)
        @@items[id.to_sym]
      end
    end

    def initialize(id)
      item = self.class.find(id) or raise NotFound
      @name, @price, @description = item.name, item.price, item.description
    end
  end

  def self.Item(id)
    Item.new(id)
  end
end

if $0 == __FILE__
  require 'minitest/autorun'

  describe Reevoo::Checkout do
    before do
      @pricing_rules = Reevoo::PricingRules.new
    end

    it 'buy-one-get-one-free' do
      # FR1,FR1 3.11
      # 3.11 * 2 == 3.11

      co = Reevoo::Checkout.new(@pricing_rules)
      co.scan(Reevoo::Item(:fr1))
      co.scan(Reevoo::Item(:fr1))

      co.total.must_equal 3.11
    end

    it 'buy-one-get-one-free, odd number' do
      # FR1,SR1,FR1,FR1,CF1
      # 3.11 * 3 == 6.22
      # (6.22 + 5.0 + 11.23)

      co = Reevoo::Checkout.new(@pricing_rules)
      co.scan(Reevoo::Item(:fr1))
      co.scan(Reevoo::Item(:sr1))
      co.scan(Reevoo::Item(:fr1))
      co.scan(Reevoo::Item(:fr1))
      co.scan(Reevoo::Item(:cf1))

      co.total.must_equal 22.45
    end

    it 'drops the price to 4.50 if you buy 3 or more strawberries' do
      # SR1,SR1,FR1,SR1
      # ( 4.50 * 3 + 3.11)

      co = Reevoo::Checkout.new(@pricing_rules)
      co.scan(Reevoo::Item(:sr1))
      co.scan(Reevoo::Item(:sr1))
      co.scan(Reevoo::Item(:fr1))
      co.scan(Reevoo::Item(:sr1))

      co.total.must_equal 16.61
    end

  end

end

