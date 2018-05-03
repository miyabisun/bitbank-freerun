require! {
  chai: {expect}
  ramda: R
  \../../classes/value.ls : Value
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Value .to.be.a \function
    specify "instance of Value", ->
      Value.from <[100 10]> |> expect >> (.to.be.an.instanceof Value)

  describe \properties, ->
    seed =
      price: \100.5
      amount: \10.5
    value = Value.from R.values seed
    seed |> R.to-pairs |> R.for-each ([name, val]) ->
      specify "#{name} is #{val}", ->
        expect value.(name) .to.be.a \number .that.equal parse-float val
