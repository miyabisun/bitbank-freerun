require! {
  \./board-record.ls : Record
  \prelude-ls : P
}
take = (length, it) --> it or [] |> (.slice 0, length)

module.exports = class Depth
  (@subscriber) ->
    @depth = {}
    @subscriber.on \message, ~> @depth = it
  @from = -> new Depth it
  on:~ -> @subscriber.on
  off:~ -> @subscriber.off
  asks: (length = 100) -> @depth.asks or [] |> take length |> (or []) |> P.map Record.from
  bids: (length = 100) -> @depth.bids or [] |> take length |> (or []) |> P.map Record.from
  ask-of: (index = 1) -> @depth.asks or [] |> (.(index - 1) or []) |> Record.from
  bid-of: (index = 1) -> @depth.bids or [] |> (.(index - 1) or []) |> Record.from
