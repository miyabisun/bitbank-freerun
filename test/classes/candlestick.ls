require! {
  chai: {expect}
  luxon: {DateTime}
  \../../classes/candlestick.ls : Candlestick
  \../../classes/ohlcv.ls : Ohlcv
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Candlestick .to.be.a \function
    specify "instance is Candlestick", ->
      Candlestick.from on: (+), off: (+)
      |> expect >> (.to.be.an.instanceof Candlestick)

  describe \properties, ->
    (candlestick = Candlestick.from on: (+), off: (+))
      ..datum = candlestick: [], timestamp: 1525104881604
    specify \datetime, ->
      expect candlestick.datetime .to.be.a.instanceof DateTime
      expect candlestick.datetime.value-of! .to.equal 1525104881604
    specify \candlestick, ->
      expect candlestick.candlestick .to.be.an \array .that.is.empty

  describe \methods, ->
    (candlestick = Candlestick.from on: (+), off: (+))
      ..datum = candlestick: [], timestamp: 1525104881604
    specify \ohlcv-by, ->
      expect candlestick.ohlcv-by(0) .to.be.an.instanceof Ohlcv
