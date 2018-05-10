require! {
  ramda: R
}
float = -> it |> (* 10_000) |> parse-float |> (/ 10_000)

module.exports = class Finance
  ({@pair, @safe = {}, @accounting}) ->
    @listeners = new Set!
    @accounting.on @update if @accounting
  @from = ({pair, to: _to, from: _from, accounting}) ->
    pair.split(\_)
    |> R.zip(_, [_to, _from])
    |> R.from-pairs
    |> -> new Finance {pair, safe: it, accounting}
  order:~ -> @accounting?.order
  from:~ -> @_from ?= @pair.split \_ .1
  to:~ -> @_to ?= @pair.split \_ .0
  money:~ ->
    money = @safe.(@from)
    return money unless @order
    switch @order.side
    | \buy => money - @order.executed-amount * @order.accounting
    | \sell => money + @order.executed-amount * @order.accounting
  amount:~ ->
    amount = @safe.(@to)
    return amount unless @order
    switch @order.side
    | \buy => amount + @order.executed-amount
    | \sell => amount - @order.executed-amount
  update:~ -> @_update ?= (order) ~>
    return if order.is-unterminated
    switch order.side
    | \buy =>
      @safe.(@from) -= order.executed-amount * order.accounting
      @safe.(@to) += order.executed-amount
    | \sell =>
      @safe.(@from) += order.executed-amount * order.accounting
      @safe.(@to) -= order.executed-amount
  buy-amount-of: (price) -> float @money / price
  stop: -> @accounting.off @update if @accounting
