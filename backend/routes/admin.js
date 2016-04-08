var express = require('express');
var router = express.Router();
var bcrypt = require('bcrypt');
var collections = require('../dbConfig.js');

router.get('/login', function(req, res, next){
    res.render('login', {displayAttr: "none", errorInfo: "foo", displayAttr2: "None", errorInfo2: "foo"});
});
router.get('/logout', function(req, res, next){
    res.cookie("authCode", "foo");
    res.redirect("/admin/login");
});

router.post('/login', function(req, res, next) {
    var username = req.body.username;
    var password = req.body.password;
    collections.Therapist.findOne({username:username}, function(err, t){
        if(err){
            res.send(err);
        }
        if (!t) {
            res.status(401).render("login", {displayAttr: "table", errorInfo: "Username not found!", displayAttr2: "None", errorInfo2: "foo"})
        }
        else {
            var hashedPassword = t.password;
            bcrypt.compare(password, hashedPassword, function(err, result){
                if (result) {   //password match
                    bcrypt.genSalt(function(err, salt) {
                        var sessionKeyEntry = new collections.SessionKey({username: username, sessionKey: salt});
                        sessionKeyEntry.save(function(err, k){
                            if(err){
                                res.status(500).send(err);
                            }
                        });
                        res.cookie('authCode', username + '|||' + salt, {maxAge: 3600000}); //expire one min later
                        setTimeout(res.redirect('/manage'),2000);
                    });
                }
                else {   //wrong password
                    res.status(401).render("login", {displayAttr: "table", errorInfo: "Wrong Password!", displayAttr2: "None", errorInfo2: "foo"})
                }
            });
        }
    });
});

router.post('/newTherapist', function(req, res, next) {
    var params = req.body;
    var username = params.username;
    var password = params.password;
    var phone = params.phone;
    var email = params.email;
    var firstName = params.firstName;
    var lastName = params.lastName;
    var patients = [];
    var APC = params.APC;

    collections.Other.findOne({}, function(err, r){
        var hashedAPC = r.APC;
        var APCVerify = bcrypt.compareSync(APC, hashedAPC);
        if (APCVerify) {
            bcrypt.genSalt(10, function(err, salt){
                bcrypt.hash(password, salt, function(err, hash){
                    password = hash;
                    var t = new collections.Therapist({
                        username: username,
                        password: password,
                        phone: phone,
                        email: email,
                        firstName: firstName,
                        lastName: lastName,
                        patients: patients
                    });
                    t.save(function(err, t) {
                        if(err) {
                            if (err.code == 11000){
                                res.render("login", {displayAttr: "None", errorInfo: "foo", displayAttr2: "table", errorInfo2: "Usernaame already exist"});
                            }
                            else{
                                res.send(err);
                            }
                        }
                        else {
                            res.render("login", {displayAttr: "None", errorInfo: "foo", displayAttr2: "None", errorInfo2: "foo"});
                        }
                    });
                });
            });
        }
        else {
            res.render("login", {displayAttr: "None", errorInfo: "foo", displayAttr2: "table", errorInfo2: "Admin Permission Code not correct! Only Admin can create an account for a therapist."});
        }
    });





});

module.exports = router;
