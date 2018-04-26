require! {
  \node-bitbankcc : bitbank
  ramda: R
}

p = <[ticker depth transactions data assets into orders order cancel]>
  |> R.map -> require "../functions/#it.ls"

public-methods = (pair, limit) ->
  api = bitbank.public-api!
  return
    ticker: -> p.ticker api, pair, limit
    depth: -> p.depth api, pair, limit
    transactions: (date) ->
      p.transactions api, pair, (parseInt date or void), limit
    data: (type, date) -> p.data api, pair, type, date, limit

private-methods = (pair, key, secret, limit) ->
  api = bitbank.private-api key, secret
  assets = -> p.assets api, limit .then (.assets)
  order = (price, amount, side, type) ->
    p.order api, pair, price, amount, side, type, limit
  return {
    assets
    into: (id) -> p.into api, pair, id, limit
    orders: -> p.orders api, pair, count: 100, limit
    order
    buy: (price, amount) -> order price, amount, \buy, \limit
    sell: (price, amount) -> order price, amount, \sell, \limit
    market-buy: (amount) -> order 0, amount, \buy, \market
    market-sell: (amount) -> order 0, amount, \sell, \market
    cancel: (id) -> p.cancel api, pair, id, limit
  }

module.exports = (pair, key, secret, limit = 5) ->
  public-methods(pair, limit) <<< private-methods(pair, key, secret, limit)
