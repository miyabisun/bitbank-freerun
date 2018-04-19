const bitbank = require('node-bitbankcc')
const P = {
  ticker: require('../functions/ticker.js'),
  depth: require('../functions/depth.js'),
  transactions: require('../functions/transactions.js'),
  data: require('../functions/data.js'),
  assets: require('../functions/assets.js'),
  info: require('../functions/info.js'),
  orders: require('../functions/orders.js'),
  order: require('../functions/order.js'),
  cancel: require('../functions/cancel.js'),
}

// publicMethods :: Undefined -> Object
const publicMethods = (pair, limit) => {
  const api = bitbank.publicApi()
  return {
    ticker: () => P.ticker(api, pair, limit),
    depth: () => P.depth(api, pair, limit),
    transactions: date => P.transactions(api, pair, (parseInt(date) || void 0), limit),
    data: (type, date) => P.data(api, pair, type, date, limit),
  }
}

// privateMethods :: Undefined -> Object
const privateMethods = (pair, key, secret, limit) => {
  const api = bitbank.privateApi(key, secret)
  const assets = () => P.assets(api, limit).then(it => it.assets)
  const order = (price, amount, side, type) => P.order(api, pair, price, amount, side, type, limit)
  return {
    assets,
    info: (id) => P.info(api, pair, id, limit),
    orders: () => P.orders(api, pair, {count: 100}, limit),
    order,
    buy: (price, amount) => order(price, amount, 'buy', 'limit'),
    sell: (price, amount) => order(price, amount, 'sell', 'limit'),
    marketBuy: amount => order(0, amount, 'buy', 'market'),
    marketSell: amount => order(0, amount, 'sell', 'market'),
    cancel: (id) => P.cancel(api, pair, id, limit),
  }
}

module.exports = (pair, key, secret, limit = 5) => ({
  ...publicMethods(pair, limit),
  ...privateMethods(pair, key, secret, limit),
})

