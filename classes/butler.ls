require! {
  ramda: R
}

module.exports = class Butler
  ({@api, @depth, @accounting})->
    @mode = null
    @orders = []
  @from = -> new Butler it
  last:~ -> R.last @orders
  cancel: -> Promise.all @orders.map -> it.cancel!
  buy: -> @mode = \buy
  sell: -> @mode = \sell
  market-buy: -> @mode = \marketBuy
  market-sell: -> @mode = \marketSell

