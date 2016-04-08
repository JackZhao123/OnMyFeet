var express = require('express');
var router = express.Router();
var auth = require('../auth.js');

/* GET home page. */
router.get('/', function(req, res, next) {
    var cookies = req.cookies;
    auth(cookies, function(r){
        if (r){
            res.render('manage', {username: cookies.authCode.split("|||")[0]});
        }
        else{
            console.log("auth failed");
            res.redirect('/admin/login');
        }
    });
});

module.exports = router;
