module.exports = class Value
  (@order) ->
  price:~ -> @order.0
  amount:~ -> @order.1
