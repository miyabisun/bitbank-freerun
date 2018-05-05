require! {
  chai: {expect}
  luxon: {DateTime}
  \node-bitbankcc : {public-api}
  \../../functions/ticker.ls : main
}
api = public-api!

file = "test#{__filename - /^.*test/}"
describe file, ->
  describe \type, ->
    specify "is function", ->
      expect main .to.be.a \function

  describe \ticket, ->
    s = result: null, main: null
    before ->>
      s.main = main api, \xrp_jpy
      s.result = await s.main
    specify "return is Promise", ->
      expect s.main .to.be.an.instanceof Promise
    specify "is object", ->
      expect s.result .to.be.a \object

    describe \properties, ->
      <[sell buy high low last]>.for-each (name) ->
        specify name, ->
          s.result.(name) is /^\d+\.\d{3}$/
          |> expect(_, s.result.(name)) >> (.to.be.ok)
      specify \vol, ->
        s.result.vol is /^\d+\.\d{4}$/
        |> expect(_, s.result.vol) >> (.to.be.ok)
      specify \timestamp, ->
        time = DateTime.from-millis s.result.timestamp
        expect time.is-valid, time.invalid-reason .to.be.ok
