module.exports = class Value
  (@order) ->
  @from = -> new Value it
  price:~ -> @order.0
  amount:~ -> @order.1
