require! {
  luxon: {DateTime}
  ramda: R
}

module.exports = class Transactions
  (@subscriber, @weights = [1])->
    @transactions = []
    @subscriber.on \message, ~> it.transactions or [] |> R.for-each ~> @transactions.push it
    @setGC!
  @from = (subscriber, weights)-> new Transactions subscriber, weights
  on:~ -> @subscriber.on
  off:~ -> @subscriber.off
  sides:~ -> @transactions |> R.take-last @weights.length |> R.map (.side)
  mean:~ ->
    @transactions
    |> R.reverse
    |> R.zip @weights, _
    |> R.filter ([weight, item])-> weight and item
    |> R.reduce do
      (arr, [weight, {side}])->
        arr.(side) += weight
        return arr
      sell: 0, buy: 0
  last:~ -> R.last @transactions
  datetime:~ -> DateTime.from-millis(this.last?.executed_at or 0)
  setGC: -> set-interval(_, 60_1000ms) ~>
    @transactions = @transactions |> R.take-last @weights.length

