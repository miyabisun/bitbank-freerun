require! {
  ramda: R
}

module.exports = class Butler
  ({@api, @depth, @accounting}) ->
    @mode = null
    @level = 0
  @from = -> new Butler it
  order:~ -> @accounting.order
  cancel: -> Promise.all @orders.map -> it.cancel!
  buy: (@level = 1) -> @mode = \buy
  sell: (@level = 1) -> @mode = \sell
  market-buy: -> @mode = \marketBuy
  market-sell: -> @mode = \marketSell

  auto-update: ->
    set-timeout (~> auto-update!), 500ms
