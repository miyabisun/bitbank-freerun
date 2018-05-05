# ticker :: PublicApi -> String -> Promise
module.exports = (api, pair) ->>
  await api.get-ticker pair
