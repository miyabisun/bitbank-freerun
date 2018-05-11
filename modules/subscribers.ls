require! {
  ramda: R
  \../classes/subscriber.ls : Subscriber
  \../classes/depth.ls
  \../classes/transactions.ls
  \../classes/candlestick.ls
}
subscribe-key = \sub-c-e12e9174-dd60-11e6-806b-02ee2ddab7fe
klass = {depth, transactions, candlestick}

module.exports = (pair) ->
  <[depth transactions candlestick]>
  |> R.map -> [it, "#{it}_#pair" |> Subscriber.from _, subscribe-key |> klass.(it).from]
  |> R.from-pairs
