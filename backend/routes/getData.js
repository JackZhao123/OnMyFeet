var express = require('express');
var router = express.Router();
var collections = require('../dbConfig.js');
var auth = require('../auth.js');

router.get('/patient',function(req, res, next){
    var id = req.query.id;
    if (!id) {
        res.status(500).send("Error: you should specify the patient ID");
    }
    else{
        collections.Patient.findOne({id: id}, function(err, p) {
            if (err) {
                res.status(500).send(err);
            }
            else if (!p) {
                res.status(500).send("Error: The patient's record is not found");
            }
            else {
                res.send(JSON.stringify(p));
            }
        });
    }
});

router.get('/therapist', function(req, res, next){
    var id = req.query.id;
    if (!id) {
        res.send("Error: you should specify the therapist ID");
    }
    else{
        collections.Therapist.findOne({username: id}, function(err, t) {
            if (err) {
                res.status(500).send(err);
            }
            else if (!t) {
                res.status(500).send("Error: The therapist's record is not found");
            }
            else {
                res.send(JSON.stringify(t));
            }
        });
    }

});

router.get('/goals', function(req, res, next){
    collections.Goal.find({}, function(err, g) {
        if (err) {
            res.status(500).send(err);
        }
        else {
            res.json(g);
        }
    });
});

router.get('/questionaire', function(req, res, next){
    collections.Questionaire.find({}, function(err, q) {
        if (err) {
            res.status(500).send(err);
        }
        else {
            res.send(JSON.stringify(q));
        }
    });
});


module.exports = router;

