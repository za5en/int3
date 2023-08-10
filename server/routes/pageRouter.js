const Router = require('express')
const router = new Router()
const pageController = require('../controllers/pageController')

router.post('/indexing', pageController.indexing)
router.get('/search', pageController.search)

module.exports = router