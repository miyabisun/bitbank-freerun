process.env <<<
  PAIR: \xrp_jpy
  LIMIT: 5
require! {
  luxon: {DateTime}
  \node-bitbankcc : bitbank
  ramda: R
  \lazy.js : L
  pubnub: PubNub
  \./modules/transactions.js
  \./modules/depth.js
  \./modules/candlestick.js
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

t = transactions.from \xrp_jpy, weights, ->
  console.log do
    t.datetime.to-format("yyyy/MM/dd HH:mm:ss")
    t.vector.to-fixed 3
    do
      sell: d.asks! |> (.0) >> (or []) >> (.0)
      buy: d.bids! |> (.0) >> (or []) >> (.0)

d = depth.from \xrp_jpy, ->
  # console.log d.asks!, d.bids!
  # console.log t.last

c = candlestick.from \xrp_jpy, ->
  # console.log c.datum
  # console.log c.ohlcv-by(\1min).data

