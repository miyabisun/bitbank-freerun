require! {
  chai: {expect}
  \../config.ls : main
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  specify "is object", ->
    expect main .to.be.an \object
  specify "has required-keys", ->
    <[pair apiKey apiSecret]>.for-each ->
      expect main.(it) .to.be.a \string
