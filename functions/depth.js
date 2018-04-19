const wait = require('./wait.js')
const main = async (api, pair, limit, retry = 0) => {
  if (retry >= limit) throw new Error('ticker is timeout')
  try {
    return await api.getDepth(pair)
  } catch (e) {
    await wait(500)
    return main(api, pair, limit, retry + 1)
  }
}

module.exports = main

