var collections = require('./dbConfig.js');

var auth = function(cookies,callback){
    var authCode = cookies.authCode;
    if (!authCode) {
        callback(false);
    }
    else {
        var usernameInCookie = authCode.split("|||")[0];
        var sessionKey = authCode.split("|||")[1];
        collections.SessionKey.findOne({username:usernameInCookie, sessionKey: sessionKey}, function(err, k) {
            if(!k) {
                callback(false);
            }
            else {
                callback(true);
            }
       });
    }
};

module.exports = auth;

