require! {
  chai: {expect}
  \../../classes/depth.ls : Depth
  \../../classes/value.ls : Value
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Depth .to.be.a \function
    specify "instance is Depth", ->
      Depth.from on: (+), off: (+)
      |> expect >> (.to.be.an.instanceof Depth)

  describe \properties, ->
    depth = Depth.from on: (+), off: (+)
    <[on off]>.for-each (type) ->
      specify "#{type} is function", ->
        expect depth.(type) .to.be.a \function

  describe \methods, ->
    (depth = Depth.from on: (+), off: (+))
      ..depth <<< asks: [[1, 2], [3, 4]], bids: [[5, 6], [7, 8]]
    [
      * \asks, [[1, 2]]
      * \bids, [[5, 6]]
    ].for-each ([type, val]) ->
      specify "#{type}(1) is #{JSON.stringify val}", ->
        depth[type] 1 |> expect >> (.to.deep.equal val)
    specify "of is Value instance", ->
      depth.of [0, 123] |> expect >> (.to.be.an.instanceof Value)
