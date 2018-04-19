const R = require('ramda')
const L = require('lazy.js')
const {DateTime} = require('luxon')
const Subscriber = require('../classes/subscriber.js')
const subscribeKey = 'sub-c-e12e9174-dd60-11e6-806b-02ee2ddab7fe'

module.exports = class Transactions {
  constructor (channel, weights) {
    this.subscriber = Subscriber.from(channel, subscribeKey)
    this.weights = weights
    this.transactions = []
    this.subscriber.on('message', msg => {
      (msg.message.data.transactions || [])
        .forEach(it => { this.transactions.push(it) })
    })
    this.setGC()
  }

  static from (pair, weights, listener) {
    const t = new Transactions(`transactions_${pair}`, weights)
    if (listener) t.subscriber.on('message', msg => listener(msg.message.data))
    return t
  }

  // getters
  get sides () { return R.takeLast(this.weights.length, this.transactions).map(R.prop('side')) }
  get mean () {
    return L(this.transactions)
      .reverse()
      .zip(this.weights)
      .filter(([item, weight]) => weight && item)
      .reduce((arr, [{side}, weight]) => {
        arr[side] += weight
        return arr
      }, {sell: 0, buy: 0})
  }
  get vector () {
    if (this.transactions.length < this.weights.length / 4) return 0
    const {sell, buy} = this.mean
    return sell <= buy
      ? Math.min(Math.sqrt(buy / sell) - 1, 10)
      : Math.max(-1 * (Math.sqrt(sell / buy) - 1), -10)
  }
  get last () { return R.last(this.transactions) }
  get datetime () { return DateTime.fromJSDate(new Date((this.last || {}).executed_at)) }

  setGC () {
    setInterval(() => {
      this.transactions = R.takeLast(this.weights.length, this.transactions)
    }, 60 * 1000)
  }
}

