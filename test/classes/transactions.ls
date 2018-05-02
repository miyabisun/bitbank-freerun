require! {
  chai: {expect}
  ramda: R
  luxon: {DateTime}
  \../../classes/transactions.ls : Transactions
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Transactions .to.be.a \function
    specify "instance is Transactions", ->
      Transactions.from on: (+), off: (+)
      |> R.tap (.stop!)
      |> expect >> (.to.be.an.instanceof Transactions)

  describe "properties (transactions is empty)", ->
    (transactions = Transactions.from on: (+), off: (+))
      ..stop!
      ..datum = transactions: [], timestamp: 1525104881604
    specify \transactions, ->
      expect transactions.transactions .to.be.an \array .that.is.empty
    <[on off]>.for-each (type) ->
      specify "#{type} is function", ->
        expect transactions.(type) .to.be.a \function
    specify \sides, ->
      expect transactions.sides .to.be.an \array .that.is.empty
    specify \mean, ->
      expect transactions.mean .to.be.a \object .that.deep.equal buy: 0, sell: 0
    specify \last, ->
      expect transactions.last .to.not.be.ok
    specify \datetime, ->
      expect transactions.datetime .to.be.an.instanceof DateTime

  describe "properties (transactions is exist)", ->
    items = [
      * transaction_id: 0, side: \buy, price: "100.5", amount: "10.5", executed_at: DateTime.local!.value-of!
      * transaction_id: 0, side: \sell, price: "100", amount: "10", executed_at: DateTime.local!.value-of!
    ]
    add-transactions = (key, cb) -> cb transactions: items
    (transactions = Transactions.from on: add-transactions, [2, 1]).stop!
    specify \transactions, ->
      expect transactions.transactions .to.be.an \array .that.length-of 2
    specify \sides, ->
      expect transactions.sides .to.be.an \array .that.deep.equal <[buy sell]>
    specify \mean, ->
      expect transactions.mean .to.be.a \object .that.deep.equal buy: 1, sell: 2
    specify \last, ->
      expect transactions.last .to.be.a \object .that.deep.equal items.1
