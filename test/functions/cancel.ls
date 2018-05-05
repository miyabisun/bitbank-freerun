require! {
  chai: {expect}
  \node-bitbankcc : {private-api}
  \../../functions/order.ls
  \../../functions/cancel.ls : main
  \../../config.ls : {api-key, api-secret}
  ramda: R
}
api = private-api api-key, api-secret

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect main .to.be.a \function

  describe "info data", ->
    s = result: null, cancel: null, order: null
    before ->>
      s.order = await order api, {pair: \xrp_jpy, price: 10, amount: 1, side: \buy, type: \limit}
      s.cancel = main api, \xrp_jpy, s.order.order_id
      s.result = await s.cancel
    specify "return is Promise", ->
      expect s.cancel .to.be.an.instanceof Promise
    specify "promise result is object", ->
      expect s.result .to.be.a \object
    <[order_id ordered_at]>.for-each (name) ->
      specify name, ->
        expect s.result.(name) .to.be.a \number
    [
      * \pair, \xrp_jpy
      * \side, \buy
      * \type, \limit
      * \start_amount, \1.000000
      * \remaining_amount, \1.000000
      * \executed_amount, \0.000000
      * \price, \10.0000
      * \average_price, \0.0000
      * \status, \CANCELED_UNFILLED
    ].for-each ([name, val]) ->
      specify "#{name} is #{JSON.stringify val}", ->
        expect s.result.(name) .to.equal val
