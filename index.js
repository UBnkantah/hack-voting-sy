const express = require('express')
const app = express()
const cors = require('cors')

require('dotenv').config({path: 'config.env'})

app.use(cors())

module.exports = app;