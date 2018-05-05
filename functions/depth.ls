# depth :: PublicApi -> String -> Promise
module.exports = (api, pair) ->>
  await api.get-depth pair
