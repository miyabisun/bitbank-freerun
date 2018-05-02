require! {
  chai: {expect}
  ramda: R
  \../../classes/accounting.ls : Accounting
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect Accounting .to.be.a \function
    specify "instance of Accounting", ->
      Accounting.from api: null
      |> R.tap (.stop!)
      |> expect >> (.to.be.an.instanceof Accounting)
  describe \properties, ->
    (accounting = Accounting.from api: 123)
      ..stop!
    [
      [\api, 123]
      [\hasOrder, no]
      [\alive, no]
    ].for-each ([key, val]) ->
      specify "#{key} is #{JSON.stringify val}", ->
        expect accounting.(key) .to.equal val
    specify "hasOrder false -> true", ->
      accounting.order = {}
      expect accounting.has-order .to.equal yes
