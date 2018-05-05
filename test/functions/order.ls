require! {
  chai: {expect}
  luxon: {DateTime}
  \node-bitbankcc : {private-api}
  \../../functions/order.ls
  \../../functions/orders.ls
  \../../functions/info.ls
  \../../functions/cancel.ls
  \../../config.ls : {api-key, api-secret}
}
api = private-api api-key, api-secret

# order関係のテストを全てこれに記載する
file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect order .to.be.a \function

  describe "order done", ->
    s = promises: {}, results: {}
    before ->>
      order-id = -> s.results.order.order_id
      tasks = [
        * \order, order, -> price: 10, amount: 1, side: \buy, type: \limit
        * \info, info, order-id
        * \orders, orders, void
        * \cancel, cancel, order-id
      ]
      for [type, fn, arg] in tasks
        while not s.results.(type)?
          try
            s.promises.(type) = fn api, \xrp_jpy, arg?!
            s.results.(type) = await s.promises.(type)
          catch
            console.error type, "is failed."

    <[order info cancel]>.for-each (type) ->
      describe type, ->
        promise = -> s.promises.(type)
        result = -> s.results.(type)
        specify "return is Promise", ->
          expect promise! .to.be.an.instanceof Promise
        specify "result is object", ->
          expect result! .to.be.a \object
        <[order_id ordered_at]>.for-each (name) ->
          specify name, ->
            expect result!.(name) .to.be.a \number
        [
          * \pair, \xrp_jpy
          * \side, \buy
          * \type, \limit
          * \start_amount, \1.000000
          * \remaining_amount, \1.000000
          * \executed_amount, \0.000000
          * \price, \10.0000
          * \average_price, \0.0000
          * \status, if type is \cancel then \CANCELED_UNFILLED else \UNFILLED
        ].for-each ([name, val]) ->
          specify "#{name} is #{JSON.stringify val}", ->
            expect result!.(name) .to.equal val
        specify "ordered_at valid time", ->
          time = DateTime.from-millis result!.ordered_at
          expect time.is-valid, time.invalid-reason .to.be.ok

    describe \orders, ->
      promise = -> s.promises.orders
      result = -> s.results.orders
      specify "return is Promise", ->
        expect promise! .to.be.an.instanceof Promise
      specify "result is object", ->
        expect result! .to.be.a \object
      describe "orders property", ->
        orders = -> result!.orders
        specify "is array", ->
          expect orders! .to.be.an \array .that.not.empty
        specify "has object", ->
          orders!.for-each expect >> (.to.be.a \object)
        <[order_id ordered_at]>.for-each (name) ->
          specify name, ->
            expect orders!.0.(name) .to.be.a \number
        [
          * \pair, \xrp_jpy
          * \side, \buy
          * \type, \limit
          * \start_amount, \1.000000
          * \remaining_amount, \1.000000
          * \executed_amount, \0.000000
          * \price, \10.0000
          * \average_price, \0.0000
          * \status, \UNFILLED
        ].for-each ([name, val]) ->
          specify "#{name} is #{JSON.stringify val}", ->
            expect orders!.0.(name) .to.equal val
        specify "ordered_at valid time", ->
          time = DateTime.from-millis orders!.0.ordered_at
          expect time.is-valid, time.invalid-reason .to.be.ok
