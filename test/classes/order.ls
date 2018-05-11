require! {
  chai: {expect}
  luxon: {DateTime}
  \prelude-ls : P
  ramda: R
  \../../classes/order.ls : Order
  \../../modules/api.ls : get-api
  \../../config.ls : {api-key, api-secret}
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Order .to.be.a \function
    specify "instance of Order", ->>
      order = await Order.from \buy, 100, 10, buy: ->> {}
      expect order .to.be.an.instanceof Order

  describe "static methods", ->>
    <[buy sell]>.for-each (type) ->
      specify type, ->>
        order = await Order.(type) 100, 10, buy: (->> {}), sell: (->> {})
        expect order .to.be.an.instanceof Order

  describe "buy -> update test", ->
    specify "successful", ->>
      api = get-api \xrp_jpy, api-key, api-secret
      order = await Order.buy 5, 1, api
      expect order.status .to.equal \UNFILLED
      await order.update!
      expect order.status .to.equal \UNFILLED
      await api.cancel order.id

  describe \properties, ->
    data =
      order_id: 123
      pair: \xrp_jpy
      side: \buy
      type: \limit
      start_amount: '10.000000'
      remaining_amount: '8.000000'
      executed_amount: '2.000000'
      price: '100.0000'
      average_price: '102.0000'
      ordered_at: DateTime.local!.value-of!
      status: \UNFILLED
    specify \data, ->>
      order = await Order.from data.side, data.price, data.start_amount, buy: (->> data)
      order.data >> expect >> (.to.deep.equal data)
    data |> P.keys |> P.filter (in <[pair side type status]>) |> P.each (key) ->
      specify key, ->>
        order = await Order.from data.side, data.price, data.start_amount, buy: (->> data)
        order |> (.(P.camelize key)) >> expect >> (.to.equal data.(key))
    data |> P.keys |> P.filter (in <[start_amount remaining_amount executed_amount average_price]>) |> P.each (key) ->
      specify key, ->>
        order = await Order.from data.side, data.price, data.start_amount, buy: (->> data)
        order |> (.(P.camelize key)) >> expect >> (.to.equal parse-float data.(key))
    specify \ordered_at, ->>
      do
        await Order.from data.side, data.price, data.start_amount, buy: (->> data)
      |> (.orderd-at) >> expect >> (.to.be.an.instanceof DateTime)
    [
      * \isTerminated, no
      * \isUnterminated, yes
      * \signA, 1
      * \signB, -1
      * \resultA, parse-float data.executed_amount
      * \resultB, - (parse-float data.executed_amount) * (parse-float data.average_price)
    ].for-each ([key, val]) ->
      specify key, ->>
        do
          await Order.from data.side, data.price, data.start_amount, buy: (->> data)
        |> (.(key)) >> expect >> (.to.equal val)
