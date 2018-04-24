process.env <<<
  PAIR: \xrp_jpy
  LIMIT: 5
require! {
  luxon: {DateTime}
  \node-bitbankcc : bitbank
  ramda: R
  \lazy.js : L
  pubnub: PubNub
  \./modules/subscribers.ls
}
weights = [
  [32, 10]
  [16, 10]
  [8, 20]
  [4, 20]
  [2, 30]
  [1, 30]
]
|> R.map ([weight, length]) -> R.repeat weight, length
|> R.flatten

vector = (t)->
  return 0 if t.transactions.length < t.weights.length / 4
  {sell, buy} = t.mean
  switch
    | sell <= buy => buy / sell |> (- 1) |> Math.sqrt |> Math.min 10, _
    | _ => sell / buy |> (- 1) |> Math.sqrt |> (* -1) |> Math.max -10, _

{transactions: t, depth: d, candlestick: c} = subscribers \xrp_jpy

t
  ..weights = weights
  ..on \message, ->
    console.log do
      t.datetime.to-format("yyyy/MM/dd HH:mm:ss")
      vector t .to-fixed 3
      do
        sell: d.asks! |> (.0) >> (or []) >> (.0)
        buy: d.bids! |> (.0) >> (or []) >> (.0)

