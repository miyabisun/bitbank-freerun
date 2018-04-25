require! {
  \./order.ls : Order
}

module.exports = class Accounting
  (@api)->
    @order = null
    @callbacks = new Set!
    @auto-update!
  @from = -> new Accounting api
  has-order:~ -> Boolean @order
  on: -> @callbacks.add it
  off: -> @callbacks.delete it
  update: ->>
    return yes unless @order
    try
      await @order.update!
      return yes if @order.is-unrminated
      @callbacks.for-each ~> it @order
      @order = null
  cancel: ->>
    return yes unless @order
    await @order.cancel!
    await @update!
  buy: (price, amount)->>
    await @cancel! if @order
    @order = await Order.from \buy, price, amount, @api
  sell: (price, amount)->>
    await @cancel! if @order
    @order = await Order.from \sell, price, amount, @api
  mrket-buy: (amount)->>
    await @cancel! if @order
    @order = await Order.from \marketBuy, 0, amount, @api
  mrket-sell: (amount)->>
    await @cancel! if @order
    @order = await Order.from \marketSell, 0, amount, @api
  auto-update: ->>
    await @update! if @order
    set-timeout (~> @auto-update!), 500

