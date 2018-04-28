require! {
  ramda: R
}

module.exports = class Butler
  ({@depth, @finance, @accounting}) ->
    @mode = null
    @level = 0
    @check!
  @from = -> new Butler it
  order:~ -> @accounting.order
  cancel: -> @mode = null; @level = 0
  buy: (@level = 1) -> @mode = \buy
  sell: (@level = 1) -> @mode = \sell
  market-buy: -> @mode = \marketBuy
  market-sell: -> @mode = \marketSell
  update:~ -> @_update ?= (msg) ~>
    #TODO:発注処理を作成する
    console.log msg
  check: -> @depth.on @update
  stop: -> @depth.off @update
