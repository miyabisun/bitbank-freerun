require! {
  chai: {expect}
  \node-bitbankcc : {private-api}
  \../../functions/assets.ls : main
  \../../config.ls : {api-key, api-secret}
  ramda: R
}
api = private-api api-key, api-secret

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect main .to.be.a \function
    specify "return is Promise", ->
      expect main(api) .to.be.an.instanceof Promise

  describe \assets, ->
    s = result: null
    before ->>
      s.result = await main(api)
    specify "is array", ->
      expect s.result.assets .to.be.an \array
    specify "has object", ->
      s.result.assets.for-each expect >> (.to.be.a \object)
    describe "asset list", ->
      specify "to list", ->
        asset-list = s.result.assets |> R.group-by (.asset)
        <[jpy btc xrp mona]>.for-each (R.prop _, asset-list) >> (.0)
          >> expect >> (.to.be.a \object)
