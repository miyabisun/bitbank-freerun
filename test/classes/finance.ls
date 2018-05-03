require! {
  chai: {expect}
  \../../classes/finance.ls : Finance
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Finance .to.be.a \function
    specify "instance is Finance", ->
      Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      |> expect >> (.to.be.an.instanceof Finance)

  describe \properties, ->
    specify \safe, ->
      Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      |> (.safe) >> expect >> (.to.deep.equal btc: 0, jpy: 20_000)
    [
      * \pair, \btc_jpy
      * \from, \jpy
      * \to, \btc
      * \fromAmount, 20_000
      * \toAmount, 0
    ].for-each ([property, value]) ->
      specify "#{property} is #{JSON.stringify value}", ->
        Finance.from pair: \btc_jpy, to: 0, from: 20_000
        |> (.(property)) >> expect >> (.to.equal value)
    specify "update is function", ->
      finance = Finance.from pair: \btc_jpy, to: 0, from: 20_000
      expect finance.update .to.be.a \function .that.equal finance.update

  describe \methods, ->
    specify "buy-amount-of 100,000 is 0.2", ->
      Finance.from pair:\btc_jpy, to: 10, from: 20_000
      |> (.buy-amount-of 100_000) >> expect >> (.to.equal 0.2)
