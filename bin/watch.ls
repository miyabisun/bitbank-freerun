require! {
  watch
  child_process: {spawn}
  \prelude-ls : P
  ramda: R
}
output = (command) -> new Promise (resolve) ->
  console.info "> #{command}"
  command.split " " |> ->
    spawn it.0, it.slice 1
      ..stdout.pipe process.stdout
      ..stderr.pipe process.stderr
      ..on \close -> resolve yes
lint = (file) ->> await output "ls-lint #{file}"
test = (file) ->> await output "mocha --colors #{file}"
hr = -> console.info "---------- ---------- ----------"

[
  [<[classes functions modules]>, "test/"]
  [<[test]>, ""]
]
|> P.each ([dirs, test-pre]) ->
  dirs |> P.each (dir) ->
    watch.create-monitor "#{__dirname}/../#{dir}", interval: 1, (m) ->
      ex = new RegExp "^.*\/#{dir}"
      m.on \changed, (f, curr, prev) ->>
        return unless f is /\.ls$/
        file = f.replace ex, dir
        await lint file
        await test "#{test-pre}#{file}"
        hr!
      process.on \SIGINT, -> m.stop!

console.info "Get Ready."
hr!
