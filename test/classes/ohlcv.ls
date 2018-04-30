require! {
  chai: {expect}
  ramda: R
  luxon: {DateTime}
  \../../classes/ohlcv.ls : Ohlcv
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Ohlcv .to.be.a \function
    specify "instance is Ohlcv", ->
      Ohlcv.from [1, 2, 3, 4, 5, 1525112155986]
      |> expect >> (.to.be.an.instanceof Ohlcv)

  describe \properties, ->
    data =
      open: 1
      high: 2
      low: 3
      close: 4
      volume: 5
      datetime: 1525112155986
    ohlcv = Ohlcv.from R.values data
    data |> R.to-pairs |> R.for-each ([key, val]) ->
      specify key, ->
        if key is \datetime
          expect ohlcv.(key) .to.be.an.instanceof DateTime
        else
          expect ohlcv.(key) .to.equal val
    specify \data, ->
      expect data .to.be.a \object .that.have.all.keys R.keys data
      data |> R.to-pairs |> R.for-each ([key, val]) ->
        if key is \datetime
          expect ohlcv.data.(key) .to.be.an.instanceof DateTime
        else
          expect ohlcv.data.(key) .to.equal val
