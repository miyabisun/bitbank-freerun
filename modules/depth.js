const Subscriber = require('../classes/subscriber.js')
const Value = require('../classes/value.js')
const subscribeKey = 'sub-c-e12e9174-dd60-11e6-806b-02ee2ddab7fe'

module.exports = class Depth {
  constructor (channel) {
    this.subscriber = new Subscriber(channel, subscribeKey)
    this.depth = {}
    this.subscriber.on('message', msg => { this.depth = msg.message.data })
  }

  // from :: String -> Function
  static from (pair, listener) {
    const d = new Depth(`depth_${pair}`, listener)
    d.subscriber.on('message', msg => listener(msg.message.data))
    return d
  }

  // asks :: Number -> [[Number, Number]...]
  asks (length = 1) {
    const asks = this.depth.asks || []
    return length ? asks.slice(0, length) : asks
  }
  // bids :: Number -> [[Number, Number]...]
  bids (length = 1) {
    const bids = this.depth.bids || []
    return length ? bids.slice(0, length) : bids
  }
  // of :: [Number, Number] -> Value
  of (value) { return new Value(value) }
}

