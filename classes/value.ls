module.exports = class Value
  (@order) ->
  @from = -> new Value it
  price:~ -> parse-float @order.0
  amount:~ -> parse-float @order.1
