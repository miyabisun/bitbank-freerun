const R = require('ramda')
const pipe = require('../functions/pipe.js')

module.exports = class Safe {
  constructor ({pair, safe = {}, accounting}) {
    this.pair = pair
    this.safe = safe
    this.accounting = accounting
  }
  static from ({pair, to, from, accounting}) {
    return pipe(
      pair.split('_'),
      R.zip(R.__, [to, from]),
      R.fromPairs,
      it => new Safe({pair, safe: it, accounting}),
    )
  }
  buyAmountOf (price) { return parseFloat(this.from / price * 10000) / 10000 }
  sellAmountOf (price) { return parseFloat(this.to / price * 10000) / 10000 }
}

