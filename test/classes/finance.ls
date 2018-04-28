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
    specify \from, ->
      Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      |> (.from) >> expect >> (.to.equal \jpy)
    specify \to, ->
      Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      |> (.to) >> expect >> (.to.equal \btc)
    specify \from-amount, ->
      Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      |> (.from-amount) >> expect >> (.to.equal 20_000)
    specify \to-amount, ->
      Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      |> (.to-amount) >> expect >> (.to.equal 0)
    specify \update, ->
      finance = Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      expect finance.update .to.be.a \function
      expect finance.update .to.equal finance.update
  describe \methods, ->
    specify \buy-amount-of, ->
      Finance.from {pair: \btc_jpy, to: 0, from: 20_000}
      |> (.buy-amount-of 100_000) >> expect >> (.to.equal 0.2)
    specify \sell-amount-of, ->
      Finance.from {pair: \btc_jpy, to: 10, from: 0}
      |> (.sell-amount-of 100_000) >> expect >> (.to.equal 10)
    specify \on, ->
      fn = -> 123
      (finance = Finance.from {pair: \btc_jpy, to: 0, from: 20_000})
        ..on fn
        ..listeners.size |> expect >> (.to.equal 1)
    specify \off, ->
      fn = -> 123
      (finance = Finance.from {pair: \btc_jpy, to: 0, from: 20_000})
        ..on fn
        ..off fn
        ..listeners.size |> expect >> (.to.equal 0)
