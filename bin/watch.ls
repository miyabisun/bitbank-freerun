require! {
  watch
  \prelude-ls : P
  ramda: R
  util: {promisify: p}
}
exec = p require(\child_process).exec
output = (command) ->>
  {stdout, stderr} = await exec command
  console.info stdout
  console.error stderr
lint = (file) ->> await output "ls-lint #{file}"
test = (file) ->> await output "mocha #{file}"
hr = -> console.info "---------- ---------- ----------"

[
  [<[classes functions modules]>, "test/"]
  [<[test]>, ""]
]
|> P.each ([dirs, test-name]) ->
  dirs |> P.each (dir) ->
    watch.create-monitor "#{__dirname}/../#{dir}", interval: 1, (m) ->
      ex = new RegExp "^.*\/#{dir}"
      m.on \changed, (f, curr, prev) ->>
        return unless f is /\.ls$/
        file = f.replace ex, dir
        await lint file
        await test "#{test-name}#{file}"
        hr!
      process.on \SIGINT, -> m.stop!

console.log "Get Ready."
