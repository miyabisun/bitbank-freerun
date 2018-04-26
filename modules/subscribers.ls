require! {
  \../classes/subscriber.ls : Subscriber
  ramda: R
}
subscribe-key = \sub-c-e12e9174-dd60-11e6-806b-02ee2ddab7fe
klass =
  depth: require \../classes/depth.ls
  transactions: require \../classes/transactions.ls
  candlestick: require \../classes/candlestick.ls

module.exports = (pair) ->
  <[depth transactions candlestick]>
  |> R.map -> [
    it
    "#{it}_#pair" |> Subscriber.from _, subscribe-key |> klass.(it).from
  ]
  |> R.from-pairs
