module.exports = {
  PAIR: process.env.PAIR || 'btc_jpy',
  API_KEY: process.env.API_KEY || '',
  API_SECRET: process.env.API_SECRET || '',
  LIMIT: parseInt(process.env.LIMIT || 3),
}

