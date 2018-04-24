require! {
  \./value.ls : Value
}

module.exports = class Depth
  (@subscriber)->
    @depth = {}
    @subscriber.on \message, ~> @depth = it
  @from = -> new Depth it
  on:~ ~> @subscriber.on
  off:~ ~> @subscriber.off
  asks: (length = 1)~> @depth.asks or [] |> (.slice 0, length)
  bids: (length = 1)~> @depth.bids or [] |> (.slice 0, length)
  of: -> new Value it

