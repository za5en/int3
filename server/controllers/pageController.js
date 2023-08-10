const {Page} = require('../models/models')
const ApiError = require('../error/apiError')

class PageController {
    async indexing(req, res, next) {
        try {
            const {url, header, text} = req.body
            const page = await Page.create({url, header, text})
            console.log(page)
            var jsonObj = {}
            var status = "status"
            var message = "message"
            var data = "data"
            
            jsonObj[status]
            jsonObj[message]
            jsonObj[data]

            var stm = 'SUCCESS'
            var mm = 'OK'
            jsonObj[status] = stm
            jsonObj[message] = mm
            jsonObj[data] = page
            JSON.stringify(jsonObj)
            return res.json(jsonObj)
        } catch (e) {
            var jsonObj = {}
            var status = "status"
            var message = "message"
            var data = "data"
            jsonObj[status]
            jsonObj[message]
            jsonObj[data]

            var error = {}
            var errorMessage = "errorMessage"
            error[errorMessage] = e.message

            var stm = 'ERROR'
            var mm = 'WRONG'
            jsonObj[status] = stm
            jsonObj[message] = mm
            jsonObj[data] = error
            JSON.stringify(jsonObj)
            return res.json(jsonObj)
            //next(ApiError.badRequest(e.message))
        }
    }

    async search(req, res, next) {
        try {
            const Sequelize = require("sequelize");
            const Op = Sequelize.Op;

            const {request} = req.query
            const pages = await Page.findAll({
                where:{
                    text: {[Op.iLike]: `%${request}%`}
                }
            })

            var result = {
                "url": [],
                "header": [],
                "text": [],
            };
            for (let i = 0; i < pages.length; i++) {
                result.url.push(pages[i].url)
                result.header.push(pages[i].header)
                var getText = pages[i].text
                var searchString = getText.toLowerCase()
                var searchSubstring = request.toLowerCase()
                var startIndex = searchString.indexOf(searchSubstring)
                var endIndex = startIndex + searchSubstring.length
                var before = ""
                var after = ""

                if (startIndex < 100) {
                    before = getText.substring(0, startIndex)
                } else {
                    before = `...${getText.substring(startIndex - 100, startIndex)}`
                }
                if (getText.length - endIndex < 100) {
                    after = getText.substring(endIndex, getText.length)
                } else {
                    after = `${getText.substring(endIndex, endIndex + 100)}...`
                }
                var word = getText.substring(startIndex, endIndex)
                if (getText[startIndex - 1] == ' ') {
                    before += ' '
                }
                if (getText[endIndex] == ' ') {
                    word += ' '
                }

                var resultText = `${before}${word}${after}`
                result.text.push(resultText)
            }
            // result.url.push(links)
            // result.header.push(headers)
            // result.text.push(texts)
            return res.json(result)
        } catch (e) {
            next(ApiError.badRequest(e.message))
        }
    }
}

module.exports = new PageController()