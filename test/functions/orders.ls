require! {
  chai: {expect}
  \./order.ls
  \../../functions/orders.ls : main
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect main .to.be.a \function
