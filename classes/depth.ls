require! {
  \./value.ls : Value
}
slice = (length, it) --> it or [] |> (.slice 0, length)

module.exports = class Depth
  (@subscriber) ->
    @depth = {}
    @subscriber.on \message, ~> @depth = it
  @from = -> new Depth it
  on:~ -> @subscriber.on
  off:~ -> @subscriber.off
  asks: (length = 1) -> @depth.asks |> slice length
  bids: (length = 1) -> @depth.bids |> slice length
  of: -> new Value it
