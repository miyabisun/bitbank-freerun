require! {
  chai: {expect}
  ramda: R
  \../../classes/board-record.ls : BoardRecord
}

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect BoardRecord .to.be.a \function
    specify "instance of BoardRecord", ->
      BoardRecord.from <[100 10]> |> expect >> (.to.be.an.instanceof BoardRecord)

  describe \properties, ->
    [
      * "order is empty array", []
      * "order is exists", [\100.5, \10.5]
    ].for-each ([title, seed]) ->
      describe title, ->
        value = BoardRecord.from seed
        <[price amount]>.for-each (name, index) ->
          specify "#{name} is #{seed.(index)}", ->
            expect value.(name) .to.be.a \number .that.equal (parse-float seed.(index) or 0)
