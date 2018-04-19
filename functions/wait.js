// wait :: Function -> Number -> Promise
module.exports = ms =>
  new Promise(resolve => {
    setTimeout(resolve, ms)
  })

