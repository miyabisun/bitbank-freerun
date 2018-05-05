require! {
  chai: {expect}
  \node-bitbankcc : {public-api}
  \../../functions/data.ls : main
  ramda: R
}
api = public-api!

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect main .to.be.a \function

  describe \assets, ->
    s = result: null, main: null
    before ->>
      s.main = main api, \xrp_jpy, \1min, \20180501
      s.result = await s.main
    specify "return is Promise", ->
      expect s.main .to.be.an.instanceof Promise
    specify "is object", ->
      expect s.result .to.be.a \object
    describe "has candlestick", ->
      specify "is object of array", ->
        expect s.result.candlestick .to.be.an \array
        s.result.candlestick.for-each expect >> (.to.be.a \object)
      specify "type is 1min", ->
        expect s.result.candlestick.0.type .to.equal \1min
      specify "ohlcv is array", ->
        expect s.result.candlestick.0.ohlcv .to.be.an \array
    describe "has timestamp", ->
      specify "is number", ->
        expect s.result.timestamp .to.be.a \number
