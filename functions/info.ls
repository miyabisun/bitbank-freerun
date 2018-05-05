# info :: PrivateApi -> String -> Number -> Promise
module.exports = (api, pair, id) ->>
  await api.get-order pair, id
