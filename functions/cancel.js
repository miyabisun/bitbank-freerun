const wait = require('./wait.js')
const info = require('./info.js')
const main = async (api, pair, id, limit, retry = 0) => {
  if (retry >= limit) throw new Error('cancel is timeout')
  try {
    return await api.cancelOrder(pair, id)
  } catch (e) {
    // 約定完了時もキャンセル失敗するので確認する
    const state = await info(api, pair, id, limit)
    if (state.status === 'FULLY_FILLED') return true
    await wait(500)
    return main(api, pair, id, limit, retry + 1)
  }
}

module.exports = main

