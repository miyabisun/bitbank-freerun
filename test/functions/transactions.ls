require! {
  chai: {expect}
  luxon: {DateTime}
  \node-bitbankcc : {public-api}
  \../../functions/transactions.ls : main
}
api = public-api!

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect main .to.be.a \function

  describe \transations, ->
    s = result: null, main: null
    before ->>
      s.main = main api, \xrp_jpy, \20180501
      s.result = await s.main
    specify "return is Promise", ->
      expect s.main .to.be.an.instanceof Promise
    specify "is object", ->
      expect s.result .to.be.a \object

    describe "transactions property", ->
      transactions = -> s.result.transactions
      specify "is array", ->
        expect transactions! .to.be.an \array

      describe \children, ->
        transaction = -> transactions!.0
        specify \transaction_id, ->
          expect transaction!.transaction_id .to.be.a \number
        specify \side, ->
          expect transaction!.side .to.be.a \string
        specify \price, ->
          expect transaction!.price .to.match /^\d+\.\d{3}$/
        specify \amount, ->
          expect transaction!.amount .to.match /^\d+\.\d{4}$/
        specify \executed_at, ->
          time = DateTime.from-millis transaction!.executed_at
          expect time.is-valid, time.invalid-reason .to.be.ok
