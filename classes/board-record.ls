module.exports = class BoardRecord
  (@order) ->
  @from = -> new BoardRecord it
  price:~ -> parse-float @order.0 or 0
  amount:~ -> parse-float @order.1 or 0
