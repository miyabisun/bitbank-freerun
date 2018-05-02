require! {
  luxon: {DateTime}
  ramda: R
}

module.exports = class Transactions
  (@subscriber, @weights = [1]) ->
    @transactions = []
    @subscriber.on \message, (.transactions or []) >> R.for-each @transactions~push
    @id = @set-gc!
  @from = (subscriber, weights) -> new Transactions subscriber, weights
  on:~ -> @subscriber.on
  off:~ -> @subscriber.off
  sides:~ -> @transactions |> R.take-last @weights.length |> R.map (.side)
  mean:~ ->
    @transactions
    |> R.reverse
    |> R.zip @weights, _
    |> R.filter ([weight, item]) -> weight and item
    |> R.reduce do
      (arr, [weight, {side}]) -> arr |> R.tap -> arr.(side) += weight
      sell: 0, buy: 0
  last:~ -> R.last @transactions
  datetime:~ -> DateTime.from-millis <| @last?.executed_at or 0
  set-gc: -> set-interval(_, 60_1000ms) ~>
    @transactions = @transactions |> R.take-last @weights.length
  stop: -> clear-interval @id
