require! {
  ramda: R
}
float = -> it |> (* 10000) |> parse-float (/ 10000)

module.exports = class Finance
  ({@pair, @safe = {}, @accounting})->
  @from = ({pair, to, from, accounting})->
    pair.split \_
    |> R.zip _, [to, from]
    |> R.from-pairs
    |> -> new Finance {pair, safe: it, accounting}
  buy-amount-of: (price)-> float @from / price
  sell-amount-of: (price)-> float @to / price

