const wait = require('./wait.js')
const main = async (api, pair, price, amount, side, type, limit, retry = 0) => {
  if (retry >= limit) throw new Error('order is timeout')
  try {
    return await api.order(pair, price, amount, side, type)
  } catch (e) {
    await wait(500)
    return main(api, pair, price, amount, side, type, limit, retry + 1)
  }
}

module.exports = main

