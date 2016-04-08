var express = require('express');
var router = express.Router();
var auth = require('../auth.js');

/* GET home page. */
router.get('/', function(req, res, next) {
  auth(req.cookies, function(r){
    if (r){
      console.log("auth successful");
      res.redirect("/manage");
    }
    else{
      console.log("auth failed");
      res.redirect('/admin/login');
    }
  });
});

module.exports = router;
