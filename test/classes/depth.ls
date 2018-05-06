require! {
  chai: {expect}
  ramda: R
  \prelude-ls : P
  \../../classes/depth.ls : Depth
  \../../classes/board-record.ls : BoardRecord
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
      * \asks, [1, 2]
      * \bids, [5, 6]
    ].for-each ([type, val]) ->
      specify "#{type}(2) is [BoardRecord]", ->
        depth[type] 2
        |> R.tap expect >> (.to.be.an \array)
        |> R.tap P.each expect >> (.to.be.an.instanceof BoardRecord)
        |> R.tap (.0.order) >> expect >> (.to.deep.equal val)
    [
      * \askOf, [1, 2]
      * \bidOf, [5, 6]
    ].for-each ([type, val]) ->
      specify "#{type}(1) is BoardRecord", ->
        depth[type] 1
        |> R.tap expect >> (.to.be.an.instanceof BoardRecord)
        |> R.tap (.order) >> expect >> (.to.deep.equal val)
