require! {
  \./order.ls : Order
}

module.exports = class Accounting
  ({@api}) ->
    @order = null
    @mode = null
    @is-proceeding = no
    @callbacks = new Set!
    @alive = yes
    @auto-update!
  @from = -> new Accounting it
  has-order:~ -> Boolean @order
  on: -> @callbacks.add it
  off: -> @callbacks.delete it
  update: ->>
    return yes unless @order
    try await @order.update!
    return yes if @order.is-unterminated
    @callbacks.for-each (<| @order)
    @order = null
    @mode = null
  cancel: ->>
    return yes unless @order
    await @order.cancel!
    await @update!
  give-order: (mode, price, amount) ->>
    @is-proceeding = yes
    await @cancel! if @order
    try
      switch (@mode = mode)
      | \buy, \marketBuy => @order = await Order.buy price, amount, @api
      | \sell, \marketSell => @order = await Order.sell price, amount, @api
    @is-proceeding = no
  auto-update: ->>
    try await @update! if @order
    set-timeout (~> @auto-update!), 500 if @alive
  stop: -> @alive = no
