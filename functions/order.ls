module.exports = (api, pair, price, amount, side, type)->>
  await api.order pair, price, amount, side, type

