module.exports = (value, ...fns) =>
  fns.reduce((val, fn) => fn(val), value)

