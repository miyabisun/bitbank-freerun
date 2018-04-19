module.exports = class Accounting {
  constructor ({api, safe, log}) {
    this.api = api
    this.safe = safe
    this.log = log
    this.order = null
    this.terminatedOrders = []
    this.callbacks = new Set()
    this.autoUpdate()
    this.gc()
  }

  static from ({api, safe, log = it => console.log(it)}) {
    return new Accounting({api, safe, log})
  }

  // getters
  get hasOrder () { Boolean(this.order) }

  // methods
  async cancel () {
    if (!this.order) return true
    await this.order.cancel()
    await this.update()
  }

  // events
  on (cb) { this.callbacks.add(cb) }
  off (cb) { this.callbacks.delete(cb) }
  async update () {
    if (!this.order) return true
    try {
      await this.order.update()
      if (this.order.isFilled) this.callbacks.forEach(cb => cb(this.order))
      this.terminatedOrders.push(this.order)
      this.order = null
    } catch (e) {}
  }
  async autoUpdate () {
    await this.update()
    setTimeout(() => this.autoUpdate(), 500)
  }
  gc () {
    if (this.terminatedOrders.length > 0) {
      this.terminatedOrders.forEach(it => this.log(it))
      this.terminatedOrders = []
    }
    setTimeout(() => this.gc(), 1000)
  }
}

