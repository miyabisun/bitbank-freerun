require! {
  luxon: {DateTime}
}

module.exports = class Ohlcv
  (@ohlcv) ->
  @from = -> new Ohlcv it
  data:~ ->
    open: @open
    high: @high
    low: @low
    close: @close
    volume: @volume
    datetime: @datetime
  open:~ -> parse-float @ohlcv.0
  high:~ -> parse-float @ohlcv.1
  low:~ -> parse-float @ohlcv.2
  close:~ -> parse-float @ohlcv.3
  volume:~ -> parse-float @ohlcv.4
  datetime:~ -> DateTime.fromMillis @ohlcv.5
