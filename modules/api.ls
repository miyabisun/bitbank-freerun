require! {
  \node-bitbankcc : bitbank
  ramda: R
}

p = <[ticker depth transactions data assets info orders order cancel]>
  |> R.map -> [it, require "../functions/#it.ls"]
  |> R.from-pairs

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
  order = ({price, amount, side, type}) ->
    p.order api, pair, {price, amount, side, type}
  return {
    assets
    info: (id) -> p.info api, pair, id
    orders: -> p.orders api, pair, count: 100, limit
    order
    buy: (price, amount) -> order {price, amount, side: \buy, type: \limit}
    sell: (price, amount) -> order {price, amount, side: \sell, type: \limit}
    market-buy: (amount) -> order {0, amount, side: \buy, type: \market}
    market-sell: (amount) -> order {0, amount, side: \sell, type: \market}
    cancel: (id) -> p.cancel api, pair, id, limit
  }

module.exports = (pair, key, secret, limit = 5) ->
  public-methods(pair, limit) <<< private-methods(pair, key, secret, limit)
