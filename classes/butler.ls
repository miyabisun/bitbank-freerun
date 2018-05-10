require! {
  ramda: R
}

module.exports = class Butler
  ({@depth, @finance, @accounting}) ->
    @mode = null
    @depth-check!
  @from = -> new Butler it

  # getters
  order:~ -> @accounting.order
  price:~ ->
    switch @mode
    | \buy => @depth.bid-of 1 .price
    | \sell => @depth.ask-of 1 .price
    # TODO: marketBuy, marketSellはちゃんとしたロジックを検討する
    | \marketBuy => @depth.ask-of 5 .price
    | \marketSell => @depth.bid-of 5 .price
  amount:~ ->
    switch @mode
    | \buy => @finance.money / @price
    | \sell => @finance.amount
    | \marketBuy => @finance.mony / @price
    | \marketSell => @finance.amount

  # methods
  give-order: (@mode) ->
  order: (mode) ->> @accounting.give-order @mode, @price, @amount
  cancel: ->>
    try await @accounting.cancel!
    @mode = null
  depth-tick:~ -> @_depth-tick ?= (msg) ~>
    switch @mode
    | \buy =>
    | \sell =>
    | \marketBuy =>
    | \marketSell =>
  depth-check: -> @depth.on @depth-tick
  depth-stop: -> @depth.off @depth-tick
  order-tick:~ -> @_order-tick ?= (order) ~>
    return if order.is-unterminated
    return if order.is-canceled
    @mode = null if @accounting.mode is @mode
  order-check: -> @accounting.on @order-tick
  order-stop: -> @accounting.off @order-tick
