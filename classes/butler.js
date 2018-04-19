const R = require('ramda')

module.exports = class Butler {
  constructor ({api, depth, accounting}) {
    this.api = api
    this.depth = depth
    this.accounting = accounting
    this.mode = null
    this.orders = []
  }

  // from :: Object -> Butler or Undefined
  static from ({api, depth, accounting}) {
    return new Butler({api, depth, accounting})
  }

  // getters
  get last () { return R.last(this.orders) }

  // methods
  async cancel () { return Promise.all(this.orders.map(_ => _.cancel())) }
  buy () { this.mode = 'buy' }
  sell () { this.mode = 'sell' }
  marketBuy () { this.mode = 'marketBuy' }
  marketSell () { this.mode = 'marketSell' }
}

