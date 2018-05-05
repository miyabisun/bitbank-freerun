require! {
  chai: {expect}
  \node-bitbankcc : {public-api}
  \../../functions/depth.ls : main
  ramda: R
}
api = public-api!

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect main .to.be.a \function

  describe \assets, ->
    s = result: null, main: null
    before ->>
      s.main = main api, \xrp_jpy
      s.result = await s.main
    specify "return is Promise", ->
      expect s.main .to.be.an.instanceof Promise
    specify "is object", ->
      expect s.result .to.be.a \object

    <[asks bids]>.for-each (name) ->
      describe "has #{name}", ->
        specify "is array of array", ->
          expect s.result.(name) .to.be.an \array
          s.result.(name).for-each expect >> (.to.be.a \array)
        <[price amount]>.for-each (type, index) ->
          specify "#{type}(#{index}) is string", ->
            expect s.result.(name).0.(index) .to.be.a \string
