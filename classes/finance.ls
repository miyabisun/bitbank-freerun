require! {
  ramda: R
}
float = -> it |> (* 10_000) |> parse-float |> (/ 10_000)

module.exports = class Finance
  ({@pair, @safe = {}, @accounting}) ->
    @listeners = new Set!
  @from = ({pair, to: _to, from: _from, accounting}) ->
    pair.split(\_)
    |> R.zip(_, [_to, _from])
    |> R.from-pairs
    |> -> new Finance {pair, safe: it, accounting}
  from:~ -> @_from ?= @pair.split \_ .1
  to:~ -> @_to ?= @pair.split \_ .0
  from-amount:~ -> float @safe.(@from)
  to-amount:~ -> float @safe.(@to)
  update:~ -> @_update ?= ~> 123
  buy-amount-of: (price) -> float @from-amount / price
  sell-amount-of: (price) -> @to-amount
  on: -> @listeners.add it
  off: -> @listeners.delete it
