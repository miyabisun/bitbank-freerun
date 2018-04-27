require! {
  chai: {expect}
  \../../modules/subscribers.ls : main
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  specify "is function", ->
    expect main .to.be.a \function
