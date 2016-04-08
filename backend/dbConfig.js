/**
 * Created by zhaosiyang on 2016-03-11.
 */
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/onMyFeet');
var collections = {};
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    var therapistSchema = mongoose.Schema({
        username: {type:String, unique: true},
        firstName: String,
        lastName: String,
        password: String,
        patientsInProgress: [String],
        patientsDischarged: [String],
        phone: String,
        email: String,
        createdAt: {type: Date, default: Date.now}
    });
    var patientSchema = mongoose.Schema({
        id: {type:String, unique: true},
        fb_id: String,
        therapistId: String,
        //firstName: String,
        //lastName: String,
        //middleName: String,
        gender: String,
        age: Number,
        //phone: String,
        //email: String,
        therapyStatus: String,   //ongoing or discharged
        capability: String,   // R, Y, G
        enterDate: String,
        leaveDate: String,
        //goals: [{id: String, progress: Number, customDescription: String}],
        goals: {type:mongoose.Schema.Types.Mixed, default: {}},
        //checkIn: [{group:String, title:String, createdAt: String, feedback: {}}],
        checkIn: {type:[mongoose.Schema.Types.Mixed], default: []},
        stepData: {type:mongoose.Schema.Types.Mixed, default: {}},
        distanceData: {type:mongoose.Schema.Types.Mixed, default: {}},
        sleepData: {type:mongoose.Schema.Types.Mixed, default: {}},
        activityData: {type:mongoose.Schema.Types.Mixed, default: {}},
        createdAt:{type: Date, default: Date.now},
        isAssginedTherapist: {type: String, default: false}
    });
    var questionaireSchema = mongoose.Schema({
        id: {type:String, unique: true},
        question: String,
        createdAt:{type: Date, default: Date.now}
    });
    //var goalSchema = mongoose.Schema({
    //    id: {type:String, unique: true},
    //    description: String,
    //    available: String,
    //    pictureURL: String,
    //    createdAt:{type: Date, default: Date.now}
    //});
    var sessionKeySchema = mongoose.Schema({
        username: String,
        sessionKey: String,
        createdAt: {type: Date, default: Date.now, expires: 3600}
    });
    var otherSchema = mongoose.Schema({
        APC:String
    });

    collections.Therapist = mongoose.model('therapist', therapistSchema);
    collections.Patient = mongoose.model('patient', patientSchema);
    collections.Questionaire = mongoose.model('question', questionaireSchema);
    //collections.Goal = mongoose.model('goal', goalSchema);
    collections.SessionKey = mongoose.model('sessionKey', sessionKeySchema);
    collections.Other = mongoose.model('other', otherSchema);
});

module.exports = collections;