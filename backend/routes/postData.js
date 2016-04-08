var express = require('express');
var router = express.Router();
var collections = require('../dbConfig.js');
var auth = require('../auth.js');

var bcrypt = require('bcrypt');

// upload data from fitbit
router.post('/fitbit', function(req, res, next) {
  var params = req.body;
  console.log(params);
  //params.stepData = JSON.parse(params.stepData);
  //params.sleepData = JSON.parse(params.sleepData);
  //params.distanceData = JSON.parse(params.distanceData);
  //params.activityData = JSON.parse(params.activityData);

  collections.Patient.findOne({fb_id: params.fb_id, therapyStatus:"ongoing"}, function(err, p){
    if (err) {
      console.log(err);
      res.status(500).send(err);
    }
    else if (!p) {
      console.log("invalid fitbit ID");
      res.send("invalid fitbit ID");
    }
    else {  // found the patient
      for (var key in params) {
        if (key == "stepData") {
          var entries = params[key];
          p[key] = p[key] || {};
          for (var key2 in entries) {
            p[key][key2] = entries[key2];
          }
          p.markModified('stepData');
        }
        else if (key == "distanceData") {
          var entries = params[key];
          p[key] = p[key] || {};
          for (var key2 in entries) {
            p[key][key2] = entries[key2];
          }
          p.markModified('distanceData');
        }
        else if (key == "sleepData") {
          var entries = params[key];
          p[key] = p[key] || {};
          for(var key2 in entries){
            p[key][key2] = entries[key2];
          }
          p.markModified('sleepData');
        }
        else if (key == "activityData") {
          var entries = params[key];
          p[key] = p[key] || {};
          for(var key2 in entries){
            p[key][key2] = entries[key2];
          }
          p.markModified('activityData');
        }
      }
      p.save(function(err, p){
        if(err) {
          console.log(err);
          res.send(err);
        }
        else {
          console.log(p);
          res.send("ok");
        }
      });
    }
  });
});
router.post('/goals', function(req, res, next){
  var params = req.body;
  var goals = params.goals;
  console.log(params);
  collections.Patient.findOne({fb_id: params.fb_id, therapyStatus:"ongoing"}, function(err, p){
    if(err){
      res.status(500).send(err);
    }
    else if (!p){
      res.status(500).send("invalid fitbit id");
    }
    else{
      p.goals = {};
      for(var key in goals){
        p.goals[key] = goals[key];
      }
      p.markModified('goals');
      p.save(function(err){
        if(err){res.status(500).send(err);}
        else{res.status(200).send('ok');}
      });
    }
  });
});

router.post('/newPatient', function(req, res, next) {     ///////////need to check if id already exist
  auth(req.cookies, function(r){
    if (r){
      var params = req.body;
      // insert entry into patients collection
      var p = new collections.Patient(params);
      p.save(function(err, p) {
        if(err) {
          res.send("Patient ID already exist");
        }
        else {
          // update therapist entry               ///////// need to delete inserted patient document
          collections.Therapist.findOne(function(err, t){
            if (err) return handleError(err);
            t.patientsInProgress.push(params.id);
            t.save(function(err, t2){
              if (err) {
                res.status(500).send("Error: patient ID already exist");
              }
              res.send("ok");
            });
          });
        }
      });
    }
    else{
      res.status(401).send("auth failed");
    }
  });
});

router.post('/modifyCapability', function(req, res, next){
  var params = req.body;
  var id = params.id;
  var newCapability = params.newCapability;
  collections.Patient.findOne({id:id}, function(err, p){
    if(err){
      res.status(500).send(err);
      return;
    }
    else if(!p){
      res.status(500).send("patient ID not found");
    }
    else{
      p.capability = newCapability;
      p.save(function(err){
        if(err){
          res.status(500).send(err);
          return;
        }
        res.status(200).send("ok");
      });
    }

  });
});

router.post('/updatePatient', function(req, res, next){
  auth(req.cookies, function(r){
    if (r){
      var params = req.body;
      var id = params.id;
      collections.Patient.findOne({id: id}, function(err, p){
        if(err) {
          res.status(500).send(err);
          return;
        }
        if(!p) {
          res.status(500).send("Error: Patient id not found");
        }
        else {
          for (var key in params) {
            p[key] = params[key];
          }
          p.save(function(err, p){
            if (err){
              res.status(500).send(err);
              return;
            }
            else {
              res.send("ok");
            }
          });
        }
      });
    }
    else{
      console.log("auth failed");
      res.redirect('/admin/login');
    }
  });
});

router.post('/discharge', function(req, res, next){
  var params = req.body;
  var id = params.id;
  collections.Patient.findOne({id: id}, function(err, p){
    if(err) {
      res.status(500).send(err);
      return;
    }
    if(!p) {
      res.send("Error: Patient id not found");
    }
    else {
      p.therapyStatus = "discharged";
      p.leaveDate = Date();
      var therapistId = p.therapistId;
      p.save(function(err, p){
        if(err){
          res.status(500).send(err);
        }
        collections.Therapist.findOne({username: therapistId}, function(err, th){
          if(err){
            res.status(500).send(err);
            return;
          }
          if(!th){
            res.status(500).send("therapist not found");
            return;
          }
          var index = th.patientsInProgress.indexOf(id);
          th.patientsInProgress.splice(index, 1);
          th.patientsDischarged.push(id);
          th.save(function(err, th){
            if(err){
              res.status(500).send(err);
              return;
            }
            res.status(200).send("ok");
          });
        });
      });
    }
  });
});

router.post('/deletePatient', function(req, res, next){
  var params = req.body;
  var id = params.id;

  collections.Patient.findOne({id: id}, function(err, p){
    if(err) {
      res.status(500).send(err);
      return;
    }
    if(!p) {
      res.send("Error: Patient id not found");
      return;
    }
    var therapistId = p.therapistId;
    p.remove(function(err, p){
      if(err){
        res.status(500).send(err);
        return;
      }
      collections.Therapist.findOne({username:therapistId}, function(err, t){
        var index = t.patientsDischarged.indexOf(id);
        t.patientsDischarged.splice(index, 1);
        t.markModified('patientsDischarged');
        t.save(function(err, t){
          if(err){
            res.status(500).send(err);
          }
          res.status(200).send("ok");
        });
      });
    });


  });
});

router.post('/feedback', function(req, res, next){
    console.log(req.body);
    collections.Patient.findOne({fb_id: req.body.fb_id, therapyStatus: "ongoing"}, function(err, patient){
    if (err) throw err;
    if (!patient){
      res.send("not valid fitbit ID");
    }
    else{
      patient.checkIn.push({
        createdAt: new Date(),
        title: req.body.title,
        group: req.body.group,
        feedback: req.body.feedback
      });
      patient.save(function(err, p){
        if(err) return handleError(err);
        res.send("ok");
      });
    }
  });
});

module.exports = router;
