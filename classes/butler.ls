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

  # methods
  give-order: (@mode) ->
  order: ->>
    switch @mode
    | \buy =>
    | \sell =>
    | \marketBuy =>
    | \marketSell =>
  buy: -> @accounting.give-order \buy, price, amount
  sell: -> @accounting.give-order \sell, price, amount
  market-buy: -> @accounting.give-order \marketBuy, price, amount
  market-sell: -> @accounting.give-order \marketSell, price, amount
  cancel: -> @accounting.cancel!
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
    switch order.side
    | \buy => @mode in <[buy marketBuy]>
    | \sell => @mode in <[sell marketSell]>
  order-check: -> @accounting.on @order-tick
  order-stop: -> @accounting.off @order-tick
