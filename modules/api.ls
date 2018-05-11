require! {
  \node-bitbankcc : bitbank
  ramda: R
}

p = <[ticker depth transactions data assets info orders order cancel]>
  |> R.map -> [it, require "../functions/#it.ls"]
  |> R.from-pairs

public-methods = (pair) ->
  api = bitbank.public-api!
  return
    ticker: -> p.ticker api, pair
    depth: -> p.depth api, pair
    transactions: (date) ->
      p.transactions api, pair, (parseInt date or void)
    data: (type, date) -> p.data api, pair, type, date

private-methods = (pair, key, secret) ->
  api = bitbank.private-api key, secret
  assets = -> p.assets api .then (.assets)
  order = ({price, amount, side, type}) ->
    p.order api, pair, {price, amount, side, type}
  return {
    assets
    info: (id) -> p.info api, pair, id
    orders: -> p.orders api, pair, count: 100
    order
    buy: (price, amount) -> order {price, amount, side: \buy, type: \limit}
    sell: (price, amount) -> order {price, amount, side: \sell, type: \limit}
    market-buy: (amount) -> order {0, amount, side: \buy, type: \market}
    market-sell: (amount) -> order {0, amount, side: \sell, type: \market}
    cancel: (id) -> p.cancel api, pair, id
  }

module.exports = (pair, key, secret) ->
  public-methods(pair) <<< private-methods(pair, key, secret)
