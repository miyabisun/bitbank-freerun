require! {
  luxon: {DateTime}
  ramda: R
  \prelude-ls : P
  \./ohlcv.ls : Ohlcv
}

module.exports = class Candlestick
  (@subscriber)->
    @subscriber.on \message, ~> @datum = it
    @datum = {}
  @from = -> new Candlestick it
  on:~ ~> @subscriber.on
  off:~ ~> @subscriber.on
  datetime:~ ~> DateTime.from-millis(@datum.timestamp or 0)
  candlestick:~ ~> @datum.candlestick or []
  ohlcv-by: (key)~>
    this.candlestick
    |> P.compact >> R.find (.type is key)
    |> (or ohlcv: [[0, 0, 0, 0, 0, 0]]) >> (.ohlcv.0) >> Ohlcb.from

