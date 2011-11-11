Ciklum test task
================

we sell only three products:
----------------------------

<table border="1">
  <tr>
    <th>Product code</td>
    <th>Name</td>
    <th>Price</td>
  </tr>
  <tr>
    <td>FR1</td>
    <td>Fruit tea</td>
    <td>3.11</td>
  </tr>
  <tr>
    <td>SR1</td>
    <td>Strawberries</td>
    <td>5.00</td>
  </tr>
  <tr>
    <td>CF1</td>
    <td>Coffee</td>
    <td>11.23</td>
  </tr>
</table>

Our CEO is a big fan of buy-one-get-one-free offers and of fruit tea. He wants us to add a rule to do this.

The COO, though, likes low prices and wants people buying strawberries to get a price discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to 4.50

Our check-out can scan items in any order, and because the CEO and COO change their minds often, it needs to be flexible regarding our pricing rules.

* The interface to our checkout looks like this (shown in Ruby):

        co = Checkout.new(pricing_rules)
        co.scan(item)
        co.scan(item)
        price = co.total


Implement a checkout system that fulfills these requirements in Ruby.


Test data
---------

Basket: FR1,SR1,FR1,FR1,CF1<br/>
Total price expected: 22.45

Basket: FR1,FR1<br/>
Total price expected: 3.11

Basket: SR1,SR1,FR1,SR1<br/>
Total price expected: 16.61

