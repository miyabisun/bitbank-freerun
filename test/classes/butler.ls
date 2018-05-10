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
      |> expect >> (.to.be.an.instanceof Butler)

  describe \getters, ->
    specify \order, ->
      options =
        depth: on: ->
        accounting: order: 123
      Butler.from options .order |> expect |> (.to.equal 123)
    specify \price, ->
      options =
        depth: on: (->), bid-of: (-> price: 123)
        accounting: order: 123
      Butler.from options
        ..give-order \buy
        ..price |> expect |> (.to.be.a \number)
    specify \amount, ->
      options =
        depth: on: (->), bid-of: (-> price: 123)
        finance: from-amount: 123
        accounting: order: 123
      Butler.from options
        ..give-order \buy
        ..amount |> expect |> (.to.be.a \number)
    specify \depth-tick, ->
      butler = Butler.from depth: on: ->
      expect butler.depth-tick .to.be.a \function
      expect butler.depth-tick .to.equal butler.depth-tick

  describe \methods, ->
    describe \give-order, ->
      <[buy sell]>.for-each (mode) ->
        specify mode, ->
          (butler = Butler.from depth: on: ->)
            ..give-order mode
            ..mode |> expect |> (.to.equal mode)
      <[marketBuy marketSell]>.for-each (mode) ->
        specify mode, ->
          (butler = Butler.from depth: on: ->)
            ..give-order mode
            ..mode |> expect |> (.to.equal mode)
    specify \cancel, ->>
      butler = Butler.from depth: {on: ->}, accounting: {cancel: ->> butler.mode = null}
      butler.give-order \buy
      await butler.cancel!
      butler.mode |> expect |> (.to.be.null)
    specify \depth-check, ->
      state = triger: null
      (.depth-check!) <| Butler.from depth: on: -> state.triger = it
      expect state.triger .to.be.a \function
    specify \depth-stop, ->
      state = triger: null
      (Butler.from depth: on: (-> state.triger = it), off: (-> state.triger = null))
        ..depth-check!
        ..depth-stop!
      expect state.triger .to.be.null
