require! {
  chai: {expect}
  \../../classes/value.ls : main
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  specify "is function", ->
    expect main .to.be.a \function
