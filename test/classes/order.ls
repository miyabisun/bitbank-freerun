require! {
  chai: {expect}
  luxon: {DateTime}
  \prelude-ls : P
  ramda: R
  \../../classes/order.ls : Order
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Order .to.be.a \function
    specify "instance of Order", ->>
      do
        await Order.from \buy, 100, 10, buy: ->> {}
      |> expect >> (.to.be.an.instanceof Order)

  describe "static methods", ->>
    <[buy sell]>.for-each (type) ->
      specify type, ->>
        do
          await Order.(type) 100, 10, buy: (->> {}), sell: (->> {})
        |> expect >> (.to.be.an.instanceof Order)

  describe \properties, ->
    data =
      order_id: 123
      side: \buy
      type: \limit
      start_amount: 10
      remaining_amount: 8
      executed_amount: 2
      price: 100
      average_price: 102
      ordered_at: DateTime.local!.value-of!
      status: \UNFILLED
    specify \data, ->>
      do
        await Order.from data.side, data.price, data.start_amount, buy: (->> {data})
      |> (.data) >> expect >> (.to.deep.equal data)
    data |> P.keys |> P.reject (in <[order_id ordered_at]>) |> P.each (key) ->
      specify key, ->>
        do
          await Order.from data.side, data.price, data.start_amount, buy: (->> {data})
        |> (.(P.camelize key)) >> expect >> (.to.equal data.(key))
    specify \ordered_at, ->>
      do
        await Order.from data.side, data.price, data.start_amount, buy: (->> {data})
      |> (.orderd-at) >> expect >> (.to.be.an.instanceof DateTime)
    [
      * \isTerminated, no
      * \isUnterminated, yes
      * \signA, 1
      * \signB, -1
      * \resultA, data.executed_amount
      * \resultB, - data.executed_amount * data.average_price
    ].for-each ([key, val]) ->
      specify key, ->>
        do
          await Order.from data.side, data.price, data.start_amount, buy: (->> {data})
        |> (.(key)) >> expect >> (.to.equal val)
