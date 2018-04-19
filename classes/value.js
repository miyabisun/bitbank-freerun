module.exports = class Value {
  constructor (order) {
    this.order = order
  }
  // getters
  get price () { return this.order[0] }
  get amount () { return this.order[1] }
}

