const {DateTime} = require('luxon')

module.exports = class Order {
  constructor (api, entity) {
    this.api = api
    this.entity = entity
  }
  // from :: String -> Number -> Number -> api -> Promise
  static async from (type, price, amount, api) {
    const entity = /^market/.test(type)
      ? api[type](amount)
      : api[type](price, amount)
    return new Order(api, await entity)
  }
  static async buy (price, amount, api) {
    return Order.from('buy', price, amount, api)
  }
  static async sell (price, amount, api) {
    return Order.from('sell', price, amount, api)
  }
  static async marketBuy (amount, api) {
    return Order.from('marketBuy', 0, amount, api)
  }
  static async marketSell (amount, api) {
    return Order.from('marketSell', 0, amount, api)
  }

  // getters
  get data () { return this.entity.data }
  get id () { return this.data.order_id }
  get side () { return this.data.size }
  get type () { return this.data.type }
  get startAmount () { return parseFloat(this.data.start_amount) }
  get remainingAmount () { return parseFloat(this.data.remaining_amount) }
  get executedAmount () { return parseFloat(this.data.executed_amount) }
  get price () { return parseFloat(this.data.price) }
  get averagePrice () { return parseFloat(this.data.average_price) }
  get orderedAt () { return DateTime.fromMillis(this.data.ordered_at) }
  get status () { return this.data.status }
  get isFilled () { return !this.isUnfilled }
  get isUnfilled () { return ['UNFILLED', 'PARTIALLY_FILLED'].includes(this.data.status) }
  // getter A vs B
  get signA () { return this.side === 'buy' ? 1 : -1 }
  get signB () { return this.side === 'sell' ? 1 : -1 }
  get resultA () { return this.signA * this.executedAmount }
  get resultB () { return this.signB * this.executedAmount * this.averagePrice }

  // cancel :: Undefined -> Promise
  async cancel () {
    if (!this.isUnfilled) return true
    try {
      await this.api.cancel(this.id)
    } catch (e) {}
  }
  // update :: Undefined -> Promise
  async update () {
    if (!this.isUnfilled) return this
    try {
      await this.api.info(this.id)
      this.entity = it
      return this
    } catch (e) {
      return this.update()
    }
  }
}

