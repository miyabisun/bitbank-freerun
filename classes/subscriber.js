const PubNub = require('pubnub')
const R = require('ramda')
const pipe = require('../functions/pipe.js')

module.exports = class Subscriber {
  constructor (channel, subscribeKey) {
    this.pubnub = new PubNub({subscribeKey})
    this.pubnub.subscribe({channels: [channel]})
    this.events = {
      status: new Set(),
      message: new Set(),
      presence: new Set(),
    }
    this.pubnub.addListener(this.listeners)
  }

  // from :: String -> Subscriber
  static from (channel, subscribeKey) {
    return new Subscriber(channel, subscribeKey)
  }

  // getters
  get listeners () {
    return pipe(
      this.events,
      R.keys,
      R.map(type => [type, value => this.events[type].forEach(fn => fn(value))]),
      R.fromPairs,
    )
  }

  // methods
  on (type, listener) {
    this.events[type].add(listener)
  }
  off (type, listener) {
    this.events[type].delete(listener)
  }
}

