main = (api, pair, id)->>
  await api.cancel-order pair, id

