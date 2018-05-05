# transactions :: PublicApi -> String -> String -> Promise
module.exports = (api, pair, date) ->>
  await api.get-transactions pair, date
