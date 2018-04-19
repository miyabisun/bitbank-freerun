const wait = require('./wait.js')
const main = async (api, pair, type, date, limit, retry = 0) => {
  if (retry >= limit) throw new Error('data is timeout')
  try {
    console.log('data:', pair, type, date)
    return await api.getCandlestick(pair, type, date)
  } catch (e) {
    await wait(500)
    return main(api, pair, type, date, limit, retry + 1)
  }
}

module.exports = main

