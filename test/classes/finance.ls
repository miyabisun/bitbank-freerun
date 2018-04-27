require! {
  chai: {expect}
  \../../classes/finance.ls : main
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  specify "is function", ->
    expect main .to.be.a \function
