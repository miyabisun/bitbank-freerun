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
      options =
        depth: on: ->
        accounting: order: 123, on: ->
      Butler.from options
      |> expect >> (.to.be.an.instanceof Butler)

  describe \getters, ->
    specify \order, ->
      options =
        depth: on: ->
        accounting: order: 123, on: ->
      Butler.from options .order |> expect |> (.to.equal 123)
    specify \price, ->
      options =
        depth: on: (->), bid-of: (-> price: 123)
        accounting: order: 123, on: ->
      Butler.from options
        ..give-order \buy
        ..price |> expect |> (.to.be.a \number)
    specify \amount, ->
      options =
        depth: on: (->), bid-of: (-> price: 123)
        finance: from-amount: 123
        accounting: order: 123, on: ->
      Butler.from options
        ..give-order \buy
        ..amount |> expect |> (.to.be.a \number)
    specify \depth-tick, ->
      options =
        depth: on: ->
        accounting: order: 123, on: ->
      butler = Butler.from options
      expect butler.depth-tick .to.be.a \function
      expect butler.depth-tick .to.equal butler.depth-tick

  describe \methods, ->
    describe \give-order, ->
      options =
        depth: on: ->
        accounting: order: 123, on: ->
      <[buy sell marketBuy marketSell]>.for-each (mode) ->
        specify mode, ->
          (butler = Butler.from options)
            ..give-order mode
            ..mode |> expect |> (.to.equal mode)
    specify \cancel, ->>
      options =
        depth: on: ->
        accounting: order: 123, on: (->), cancel: ->> butler.mode = null
      butler = Butler.from options
      butler.give-order \buy
      await butler.cancel!
      butler.mode |> expect |> (.to.be.null)
    specify \depth-check, ->
      state = type: null, triger: null
      options =
        depth:
          on: (type, triger) -> state <<< {type, triger}
          off: (type, triger) -> state <<< {type: null, triger: null}
        accounting: order: 123, on: ->
      Butler.from options
        ..depth-stop!
        ..depth-check!
      expect state.type .to.equal \message
      expect state.triger .to.be.a \function
    specify \depth-stop, ->
      state = triger: null
      options =
        depth: on: ((_, it) -> state.triger = it), off: (-> state.triger = null)
        accounting: order: 123, on: ->
      Butler.from options
        ..depth-stop!
      expect state.triger .to.be.null
