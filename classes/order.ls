require! {
  luxon: {DateTime}
}

module.exports = class Order
  (@api, @entity) ->
  @from = (type, price, amount, api) ->>
    entity = if type is /^market/
      then api.(type) amount
      else api.(type) price, amount
    new Order api, await entity
  @buy = (price, amount, api) ->>
    Order.from \buy, price, amount, api
  @sell = (price, amount, api) ->>
    Order.from \sell, price, amount, api

  # getters
  data:~ -> @entity.data or {}
  id:~ -> @data.order_id
  side:~ -> @data.side
  type:~ -> @data.type
  start-amount:~ -> parse-float @data.start_amount
  remaining-amount:~ -> parse-float @data.remaining_amount
  executed-amount:~ -> parse-float @data.executed_amount
  price:~ -> parse-float @data.price
  average-price:~ -> parse-float @data.average_price
  orderd-at:~ -> DateTime.from-millis @data.ordered_at
  status:~ -> @data.status
  is-terminated:~ -> not @is-unterminated
  is-unterminated:~ -> @status in <[UNFILLED PARTIALLY_FILLED]>
  is-canceled:~ -> @status in <[CANCELED_UNFILLED CANCELED_PARTIALLY_FILLED]>

  # A vs B
  sign-a:~ -> if @side is \buy then 1 else -1
  sign-b:~ -> if @side is \sell then 1 else -1
  result-a:~ -> @sign-a * @executed-amount
  result-b:~ -> @sign-b * @executed-amount * @average-price

  cancel: ->>
    return @ if @is-terminated
    try
      await @api.cancel @id
      await @update!
    return @
  update: ->>
    return @ if @is-terminated
    try
      @entity = await @api.info @id
    catch
      @update!
    return @
