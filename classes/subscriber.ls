require! {
  pubnub: PubNub
  \prelude-ls : P
  ramda: R
}

module.exports = class Subscriber
  (@channel, @subscribe-key) ->
    @events = <[status message presence]>
      |> R.map -> [it, new Set()]
      |> R.from-pairs
    (@pubnub = new PubNub {subscribe-key})
      ..subscribe channels: [channel]
      ..addListener do
        status: (val) ~> @events.status.for-each -> it val
        message: (val) ~> @events.message.for-each -> it val.message.data
        presence: (val) ~> @events.presence.for-each -> it val
  @from = (channel, subscribe-key) -> new Subscriber channel, subscribe-key
  on: (type, fn) -> @events.(type).add fn
  off: (type, fn) -> @events.(type).delete fn
