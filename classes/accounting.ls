require! {
  \./order.ls : Order
}

module.exports = class Accounting
  ({@api}) ->
    @order = null
    @callbacks = new Set!
    @alive = yes
    @auto-update!
  @from = -> new Accounting it
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
  buy: (price, amount) ->>
    await @cancel! if @order
    @order = await Order.buy price, amount, @api
  sell: (price, amount) ->>
    await @cancel! if @order
    @order = await Order.sell price, amount, @api
  mrket-buy: (amount) ->>
    await @cancel! if @order
    @order = await Order.market-buy amount, @api
  mrket-sell: (amount) ->>
    await @cancel! if @order
    @order = await Order.market-sell amount, @api
  auto-update: ->>
    await @update! if @order
    set-timeout (~> @auto-update!), 500 if @alive
  stop: -> @alive = no
