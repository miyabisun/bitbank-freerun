# data :: PublicApi -> String -> String -> 
module.exports =  (api, pair, type, date) ->>
  await api.get-candlestick pair, type, date
