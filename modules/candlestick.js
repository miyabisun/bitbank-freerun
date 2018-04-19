const R = require('ramda')
const L = require('lazy.js')
const pipe = require('../functions/pipe.js')
const {DateTime} = require('luxon')
const Subscriber = require('../classes/subscriber.js')
const Ohlcv = require('../classes/ohlcv.js')
const subscribeKey = 'sub-c-e12e9174-dd60-11e6-806b-02ee2ddab7fe'

module.exports = class Candlestick {
  constructor (channel) {
    this.subscriber = Subscriber.from(channel, subscribeKey)
    this.subscriber.on('message', msg => { this.datum = msg.message.data })
    this.datum = {}
  }

  static from (pair, listener) {
    const c = new Candlestick(`candlestick_${pair}`, listener)
    if (listener) c.subscriber.on('message', msg => listener(msg.message.data))
    return c
  }

  // getters
  get datetime () {
    return DateTime.fromMillis(this.datum.timestamp || 0)
  }
  get candlestick () {
    return this.datum.candlestick || []
  }

  // methods
  ohlcvBy (key) {
    return pipe(
      L(this.candlestick)
        .compact()
        .findWhere({ type: key }),
      R.defaultTo({ohlcv: [[0, 0, 0, 0, 0, 0]]}),
      R.path(['ohlcv', 0]),
      it => new Ohlcv(it)
    )
  }
}

