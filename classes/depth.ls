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
  asks: (length = 1) -> @depth.asks or [] |> slice length
  bids: (length = 1) -> @depth.bids or [] |> slice length
  of: -> Value.from it
