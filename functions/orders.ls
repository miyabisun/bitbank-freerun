# orders :: PrivateApi -> String -> Object -> Promises
module.exports = (api, pair, options = {}) ->>
  await api.get-active-orders pair, options
