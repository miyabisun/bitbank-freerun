require! {
  fs, path
  child_process: {spawn}
  \prelude-ls : P
}
output = (command) -> new Promise (resolve) ->
  console.info "> #{command}"
  command.split " " |> ->
    spawn it.0, it.slice 1
      ..stdout.pipe process.stdout
      ..stderr.pipe process.stderr
      ..on \close -> resolve yes
lint = (...files) ->> await output "ls-lint #{files.join ' '}"
test = (file) ->> await output "mocha --colors #{file}"
hr = -> console.info "---------- ---------- ----------"

[\classes, \functions, \modules, ""]
|> P.each (dir) ->
  tasks = new Set!
  ["#{dir or \.}", "test/#{dir}"].for-each fs.watch _, (type, file) ->>
    return if type isnt \change
    return if file isnt /\.ls$/
    return if tasks.has file
    tasks.add file
    try
      if dir
        await lint "#{dir}/#{file}", "test/#{dir}/#{file}"
        await test "test/#{dir}/#{file}"
      else
        await lint "#{file}", "test/#{file}"
        await test "test/#{file}"
      hr!
    tasks.delete file

console.info "Get Ready."
hr!
