const wait = require('./wait.js')
const main = async (api, limit, retry = 0) => {
  if (retry >= limit) throw new Error('ticker is timeout')
  try {
    return await api.getAsset()
  } catch (e) {
    await wait(500)
    return main(api, limit, retry + 1)
  }
}

module.exports = main

