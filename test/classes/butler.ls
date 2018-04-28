require! {
  chai: {expect}
  ramda: R
  \../../classes/butler.ls : Butler
  \../../classes/depth.ls : Depth
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Butler .to.be.a \function
    specify "instance is Butler", ->
      Butler.from depth: on: ->
      |> R.tap expect >> (.to.be.an.instanceof Butler)

  describe \getters, ->
    specify \order, ->
      options =
        depth: on: ->
        accounting: order: 123
      Butler.from options .order |> expect |> (.to.equal 123)
    specify \update, ->
      butler = Butler.from depth: on: ->
      expect butler.update .to.be.a \function
      expect butler.update .to.equal butler.update

  describe \methods, ->
    <[buy sell]>.for-each (mode) ->
      specify mode, ->
        (butler = Butler.from depth: on: ->)
          ..[mode]!
          ..mode |> expect |> (.to.equal mode)
          ..level |> expect |> (.to.equal 1)
        butler
          ..[mode] 2
          ..mode |> expect |> (.to.equal mode)
          ..level |> expect |> (.to.equal 2)
    <[marketBuy marketSell]>.for-each (mode) ->
      specify mode, ->
        (butler = Butler.from depth: on: ->)
          ..[mode]!
          ..mode |> expect |> (.to.equal mode)
    specify \cancel, ->
      (butler = Butler.from depth: on: ->)
        ..buy!
        ..cancel!
        ..mode |> expect |> (.to.be.null)
        ..level |> expect |> (.to.equal 0)
    specify \check, ->
      state = triger: null
      Butler.from depth: on: -> state.triger = it
        .check!
      expect state.triger .to.be.a \function
    specify \stop, ->
      state = triger: null
      (Butler.from depth: {on: (-> state.triger = it), off: -> state.triger = null})
        ..check!
        ..stop!
      expect state.triger .to.be.null
