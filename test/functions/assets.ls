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

  describe \assets, ->
    s = result: null, promise: null
    result = -> s.result
    promise = -> s.promise
    before ->>
      s.promise = main api
      s.result = await s.promise

    specify "is promise", ->
      expect promise! .to.be.an.instanceof Promise
    specify "result is object", ->
      expect result! .to.be.a \object
    describe "assets property", ->
      assets = -> result!.assets
      specify "result is array", ->
        expect assets! .to.be.an \array
      specify "has object", ->
        assets!.for-each expect >> (.to.be.a \object)
      describe "asset list", ->
        specify "to list", ->
          asset-list = assets! |> R.group-by (.asset)
          <[jpy btc xrp mona]>.for-each (R.prop _, asset-list) >> (.0)
            >> expect >> (.to.be.a \object)
