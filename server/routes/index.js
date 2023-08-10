const Router = require('express')
const router = new Router()
const pageRouter = require('./pageRouter')

router.use('/page', pageRouter)

module.exports = router