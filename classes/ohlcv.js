const {DateTime} = require('luxon')

module.exports = class Ohlcv {
  constructor (ohlcv) {
    this.ohlcv = ohlcv
  }
  // getter
  get data () {
    return {
      open: this.open,
      high: this.high,
      low: this.low,
      close: this.close,
      volume: this.volume,
      datetime: this.datetime,
    }
  }
  get open () { return parseFloat(this.ohlcv[0]) }
  get high () { return parseFloat(this.ohlcv[1]) }
  get low () { return parseFloat(this.ohlcv[2]) }
  get close () { return parseFloat(this.ohlcv[3]) }
  get volume () { return parseFloat(this.ohlcv[4]) }
  get datetime () { return DateTime.fromMillis(this.ohlcv[5]) }
}

