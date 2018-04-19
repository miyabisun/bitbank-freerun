const wait = require('./wait.js')
const main = async (api, pair, options, limit, retry = 0) => {
  if (retry >= limit) throw new Error('ticker is timeout')
  try {
    return await api.getActiveOrders(pair, options)
  } catch (e) {
    await wait(500)
    return main(api, pair, options, limit, retry + 1)
  }
}

module.exports = main

