const Order = require('./order.js')

module.exports = class Accounting {
  constructor (api) {
    this.api = api
    this.order = null
    this.callbacks = new Set()
    this.autoUpdate()
  }

  static from (api) {
    return new Accounting(api)
  }

  // getters
  get hasOrder () { Boolean(this.order) }

  // methods
  on (cb) { this.callbacks.add(cb) }
  off (cb) { this.callbacks.delete(cb) }
  async update () {
    if (!this.order) return true
    try {
      await this.order.update()
      if (this.order.isUnrminated) return true
      this.callbacks.forEach(cb => cb(this.order))
      this.order = null
    } catch (e) {}
  }
  async cancel () {
    if (!this.order) return true
    await this.order.cancel()
    await this.update()
  }
  async buy (price, amount, api) {
    if (this.order) await this.cancel()
    this.order = await Order.from('buy', price, amount, api)
  }
  async sell (price, amount, api) {
    if (this.order) await this.cancel()
    this.order = await Order.from('sell', price, amount, api)
  }
  async marketBuy (amount, api) {
    if (this.order) await this.cancel()
    this.order = await Order.from('marketBuy', 0, amount, api)
  }
  async marketSell (amount, api) {
    if (this.order) await this.cancel()
    this.order = await Order.from('marketSell', 0, amount, api)
  }
  async autoUpdate () {
    if (this.order) await this.update()
    setTimeout(() => this.autoUpdate(), 500)
  }
}

