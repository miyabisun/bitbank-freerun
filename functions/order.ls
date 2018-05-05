# order :: PrivateApi -> String -> Object -> Promise
module.exports = (api, pair, {price, amount, side, type}:options) ->>
  await api.order pair, price, amount, side, type
