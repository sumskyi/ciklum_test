#!/usr/bin/env ruby

module Reevoo
  class Checkout
    def scan(item)
    end

    def total
    end
  end

  class PricingRules
  end

  class Item
    def initialize(name)
    end
  end

  def self.Item(name)
    Item.new(name)
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

