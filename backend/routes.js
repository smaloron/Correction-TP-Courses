const router = require('express').Router();
const controller = require('./controllers');

router.get('/article', controller.getAllArticles);

module.exports = router;
