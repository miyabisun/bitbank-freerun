require! {
  ramda: R
}

module.exports = class Butler
  ({@depth, @finance, @accounting}) ->
    @mode = null
    @depth-check!
    @order-check!
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
  do-order: ->>
    @accounting~give-order @mode, @price, @amount
  cancel: ->>
    try await @accounting.cancel!
    @mode = null
  depth-tick:~ -> @_depth-tick ?= (msg) ~>>
    return unless @mode
    return if @accounting.is-proceeding
    return if @amount < 0.01
    console.log \butler:, \depth-tick, @mode
    switch
    | not @order =>
      console.log \butler:, @mode, \!
      @do-order!
    | @mode isnt @accounting.mode =>
      try await @accounting.cancel!
      console.log \butler:, @mode, \!
      @do-order!
    | @mode in <[buy sell]> and @price isnt @order.price =>
      try await @accounting.cancel!
      console.log \butler:, @mode, \!
      @do-order!
  depth-check: -> @depth~on \message, @depth-tick
  depth-stop: -> @depth~off \message, @depth-tick
  order-tick:~ -> @_order-tick ?= (order) ~>
    return if order.is-unterminated
    return if order.is-canceled
    @mode = null if @accounting.mode is @mode
  order-check: -> @accounting~on @order-tick
  order-stop: -> @accounting~off @order-tick
