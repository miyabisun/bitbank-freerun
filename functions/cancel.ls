# cancel :: PrivateApi -> String -> Number -> Promise
module.exports = (api, pair, id) ->>
  await api.cancel-order pair, id
