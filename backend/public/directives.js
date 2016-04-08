/**
 * Created by zhaosiyang on 2016-03-03.
 */
(function(){
    var app = angular.module('directives', []);

    app.directive('topNavBar', function(){
        return {
            templateUrl: "/templates/topNavBar.html"
        };
    });
    app.directive('coreDataArea', function(){
       return {
           templateUrl: "/templates/coreDataArea.html",
           controller: function(globalVariable, $scope, $http){
               $scope.parseInt = parseInt;
               $scope.globalVariable = globalVariable;
               $scope.globalVariable.getFeedback = function(patientId){
                   $http.get('getData/patient?id='+patientId).then(function(response){
                       $scope.feedbackContents = response.data.checkIn;
                   });
               };
               $scope.changeDataScope = function(buttonType){
                   if($scope.globalVariable.showType === "step"){
                       if(buttonType === "start"){
                           var stepData = $scope.globalVariable.stepData;
                           var stepDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber;
                           $scope.globalVariable.endIndex = showNumber - 1;
                           $scope.globalVariable.startIndex = 0;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.stepData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.stepDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.stepDataDisplay[item] = stepData[item];
                           });
                           $scope.globalVariable.drawStep();
                       }
                       else if (buttonType === "end"){
                           var stepData = $scope.globalVariable.stepData;
                           var stepDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber;
                           $scope.globalVariable.endIndex = stepDataLength - 1 ;
                           $scope.globalVariable.startIndex = stepDataLength - showNumber;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.stepData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.stepDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.stepDataDisplay[item] = stepData[item];
                           });
                           $scope.globalVariable.drawStep();
                       }
                       else if (buttonType === "previous"){
                           var stepData = $scope.globalVariable.stepData;
                           var stepDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber;
                           $scope.globalVariable.endIndex -= 1 ;
                           $scope.globalVariable.startIndex -= 1;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.stepData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.stepDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.stepDataDisplay[item] = stepData[item];
                           });
                           $scope.globalVariable.drawStep();
                       }
                       else if (buttonType === "next"){
                           var stepData = $scope.globalVariable.stepData;
                           var stepDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber;
                           $scope.globalVariable.endIndex += 1 ;
                           $scope.globalVariable.startIndex += 1;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.stepData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.stepDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.stepDataDisplay[item] = stepData[item];
                           });
                           $scope.globalVariable.drawStep();
                       }
                   }
                   else if ($scope.globalVariable.showType === "distance"){
                       if(buttonType === "start"){
                           var distanceData = $scope.globalVariable.distanceData;
                           var distanceDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber || 7;
                           $scope.globalVariable.endIndex = showNumber - 1;
                           $scope.globalVariable.startIndex = 0;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.distanceData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.distanceDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.distanceDataDisplay[item] = distanceData[item];
                           });
                           $scope.globalVariable.drawDistance();
                       }
                       else if (buttonType === "end"){
                           var distanceData = $scope.globalVariable.distanceData;
                           var distanceDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber;
                           $scope.globalVariable.endIndex = distanceDataLength - 1 ;
                           $scope.globalVariable.startIndex = distanceDataLength - showNumber;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.distanceData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.distanceDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.distanceDataDisplay[item] = distanceData[item];
                           });
                           $scope.globalVariable.drawDistance();
                       }
                       else if (buttonType === "previous"){
                           var distanceData = $scope.globalVariable.distanceData;
                           var distanceDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber;
                           $scope.globalVariable.endIndex -= 1 ;
                           $scope.globalVariable.startIndex -= 1;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.distanceData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.distanceDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.distanceDataDisplay[item] = distanceData[item];
                           });
                           $scope.globalVariable.drawDistance();
                       }
                       else if (buttonType === "next"){
                           var distanceData = $scope.globalVariable.distanceData;
                           var distanceDataLength = $scope.globalVariable.dataNumber;
                           var showNumber = $scope.globalVariable.showNumber;
                           $scope.globalVariable.endIndex += 1 ;
                           $scope.globalVariable.startIndex += 1;
                           var endIndex = $scope.globalVariable.endIndex;
                           var startIndex = $scope.globalVariable.startIndex;
                           var keysToDisplay = Object.keys($scope.globalVariable.distanceData).sort().slice(startIndex, endIndex+1);
                           $scope.globalVariable.distanceDataDisplay = {};
                           keysToDisplay.forEach(function(item){
                               $scope.globalVariable.distanceDataDisplay[item] = distanceData[item];
                           });
                           $scope.globalVariable.drawDistance();
                       }
                   }
                   else if ($scope.globalVariable.showType === "sleep"){
                       if(buttonType === "start"){
                           $scope.globalVariable.sleepDataIndexDisplayed = 0;
                           $scope.globalVariable.startIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.sleepDatakeyDisplayed = $scope.globalVariable.sleepDatakeysInOrder[$scope.globalVariable.sleepDataIndexDisplayed];
                           $scope.globalVariable.sleepDataDisplayed = $scope.globalVariable.sleepData[$scope.globalVariable.sleepDatakeyDisplayed];
                           $scope.globalVariable.drawSleep();
                       }
                       else if (buttonType === "end"){
                           $scope.globalVariable.sleepDataIndexDisplayed = $scope.globalVariable.sleepDatakeysInOrder.length - 1;
                           $scope.globalVariable.startIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.sleepDatakeyDisplayed = $scope.globalVariable.sleepDatakeysInOrder[$scope.globalVariable.sleepDataIndexDisplayed];
                           $scope.globalVariable.sleepDataDisplayed = $scope.globalVariable.sleepData[$scope.globalVariable.sleepDatakeyDisplayed];
                           $scope.globalVariable.drawSleep();
                       }
                       else if (buttonType === "previous"){
                           $scope.globalVariable.sleepDataIndexDisplayed -= 1;
                           $scope.globalVariable.startIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.sleepDatakeyDisplayed = $scope.globalVariable.sleepDatakeysInOrder[$scope.globalVariable.sleepDataIndexDisplayed];
                           $scope.globalVariable.sleepDataDisplayed = $scope.globalVariable.sleepData[$scope.globalVariable.sleepDatakeyDisplayed];
                           $scope.globalVariable.drawSleep();
                       }
                       else if (buttonType === "next"){
                           $scope.globalVariable.sleepDataIndexDisplayed += 1;
                           $scope.globalVariable.startIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                           $scope.globalVariable.sleepDatakeyDisplayed = $scope.globalVariable.sleepDatakeysInOrder[$scope.globalVariable.sleepDataIndexDisplayed];
                           $scope.globalVariable.sleepDataDisplayed = $scope.globalVariable.sleepData[$scope.globalVariable.sleepDatakeyDisplayed];
                           $scope.globalVariable.drawSleep();
                       }
                   }
                   else if ($scope.globalVariable.showType === "activity"){
                       if(buttonType === "start"){
                           $scope.globalVariable.activityDataIndexDisplayed = 0;
                           $scope.globalVariable.startIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.activityDatakeyDisplayed = $scope.globalVariable.activityDatakeysInOrder[$scope.globalVariable.activityDataIndexDisplayed];
                           $scope.globalVariable.activityDataDisplayed = $scope.globalVariable.activityData[$scope.globalVariable.activityDatakeyDisplayed];
                           $scope.globalVariable.drawActivity();
                       }
                       else if (buttonType === "end"){
                           $scope.globalVariable.activityDataIndexDisplayed = $scope.globalVariable.activityDatakeysInOrder.length - 1;
                           $scope.globalVariable.startIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.activityDatakeyDisplayed = $scope.globalVariable.activityDatakeysInOrder[$scope.globalVariable.activityDataIndexDisplayed];
                           $scope.globalVariable.activityDataDisplayed = $scope.globalVariable.activityData[$scope.globalVariable.activityDatakeyDisplayed];
                           $scope.globalVariable.drawActivity();
                       }
                       else if (buttonType === "previous"){
                           $scope.globalVariable.activityDataIndexDisplayed -= 1;
                           $scope.globalVariable.startIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.activityDatakeyDisplayed = $scope.globalVariable.activityDatakeysInOrder[$scope.globalVariable.activityDataIndexDisplayed];
                           $scope.globalVariable.activityDataDisplayed = $scope.globalVariable.activityData[$scope.globalVariable.activityDatakeyDisplayed];
                           $scope.globalVariable.drawActivity();
                       }
                       else if (buttonType === "next"){
                           $scope.globalVariable.activityDataIndexDisplayed += 1;
                           $scope.globalVariable.startIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.endIndex = $scope.globalVariable.activityDataIndexDisplayed;
                           $scope.globalVariable.activityDatakeyDisplayed = $scope.globalVariable.activityDatakeysInOrder[$scope.globalVariable.activityDataIndexDisplayed];
                           $scope.globalVariable.activityDataDisplayed = $scope.globalVariable.activityData[$scope.globalVariable.activityDatakeyDisplayed];
                           $scope.globalVariable.drawActivity();
                       }
                   }
               };
               //$scope.goals = {
               //    "watch TV with family": 600,
               //    "go to the park": 400,
               //    "walk my dog": 700,
               //    "play ping pong": 550
               //};
               $scope.globalVariable.getClassByCapability = function(){
                   if($scope.globalVariable.selectedPatientCapability === 'B'){
                       return 'alert-info';
                   }
                   else if($scope.globalVariable.selectedPatientCapability === 'Y'){
                       return 'alert-warning';
                   }
                   else if($scope.globalVariable.selectedPatientCapability === 'R'){
                       return 'alert-danger';
                   }
               }
           }
       };
    });
    app.directive('addPatient', function(){
        return {
            templateUrl: "/templates/addPatient.html",
            controller: function(globalVariable,$scope, $rootScope, $http){
                $scope.submit = function(){
                    var data = {
                        id: $scope.patientId,
                        fb_id: $scope.fitbitId,
                        therapistId: $rootScope.username,
                        therapyStatus: "ongoing",
                        firstName: $scope.firstName,
                        lastName: $scope.lastName,
                        middleName: $scope.middleName,
                        gender: $scope.gender,
                        age: $scope.age,
                        phone: $scope.phone,
                        email: $scope.email,
                        capability: $scope.capability,
                        enterDate: new Date(),
                        leaveDate: null
                    };

                    $http.post('/postData/newPatient', data).then(function(response){
                        if (response.data === "ok") {
                            alert("Successfully created the therapist account!");
                            location.href = '/manage';
                            //globalVariable.getPatients();
                        }
                        if (response.data === "Patient ID already exist") {
                            alert("Error: Patient ID already exist");
                        }
                    }, function(error){
                        alert("Session expired please log in again");
                        location.href = "/";
                    });
                };
            }
        };
    });
    app.directive('sideNavBar', function(){
        return {
            templateUrl: "/templates/sideNavBar.html",
            controller: function($scope, $rootScope, globalVariable, $http){
                $scope.globalVariable = globalVariable;
                ($scope.globalVariable.getPatients = function(){
                    $http.get('/getData/therapist?id='+$rootScope.username).then(function(response){
                        var therapist = response.data;
                        $scope.patientsInProgressDisplay = {};
                        $scope.patientsDischargedDisplay = {};
                        for (var i in therapist.patientsInProgress){
                            $scope.patientsInProgressDisplay[therapist.patientsInProgress[i]] = false;
                        }
                        for (var j in therapist.patientsDischarged){
                            $scope.patientsDischargedDisplay[therapist.patientsDischarged[j]] = false;
                        }
                    });
                })();

                $scope.toggleActive = function(id){
                    if ($scope.patientsInProgressDisplay[id] == undefined){
                        $scope.patientsDischargedDisplay[id] = !$scope.patientsDischargedDisplay[id];
                    }
                    else if ($scope.patientsDischargedDisplay[id] == undefined){
                        $scope.patientsInProgressDisplay[id] = !$scope.patientsInProgressDisplay[id];
                    }
                };

                $scope.switchType = function (showType, selectedPatientId){
                    $scope.globalVariable.showType = showType;
                    $scope.globalVariable.selectedPatientId = selectedPatientId;
                    if (showType == "step") {
                        $http.get('getData/patient?id='+ selectedPatientId).then(function(response){
                            $scope.globalVariable.selectedPatientAge = response.data.age;
                            $scope.globalVariable.selectedPatientFitBitId = response.data.fb_id;
                            $scope.globalVariable.selectedPatientGender = response.data.gender;
                            $scope.globalVariable.selectedPatientStartTime = response.data.enterDate.slice(0, 10);
                            $scope.globalVariable.selectedPatientCapability = response.data.capability;

                            $scope.globalVariable.stepData = response.data.stepData;
                            if($scope.globalVariable.stepData && $scope.globalVariable.stepData != {}){
                                $scope.globalVariable.endIndex = Object.keys($scope.globalVariable.stepData).length - 1;
                                var stepDataKeys = Object.keys($scope.globalVariable.stepData);
                                $scope.globalVariable.showNumber = 9;
                                $scope.globalVariable.dataNumber= stepDataKeys.length;
                                if (stepDataKeys.length < $scope.globalVariable.showNumber){
                                    $scope.globalVariable.startIndex = 0;
                                    $scope.globalVariable.stepDataDisplay = $scope.globalVariable.stepData;
                                }
                                else{
                                    var keysToShow = stepDataKeys.sort().slice(-$scope.globalVariable.showNumber);
                                    $scope.globalVariable.stepDataDisplay = {};
                                    $scope.globalVariable.startIndex = Object.keys($scope.globalVariable.stepData).length - $scope.globalVariable.showNumber;
                                    keysToShow.forEach(function(item){
                                        $scope.globalVariable.stepDataDisplay[item] = $scope.globalVariable.stepData[item];
                                    });
                                }
                                $scope.globalVariable.drawStep();
                            }
                            else{
                                $scope.globalVariable.stepData = {};
                                $scope.globalVariable.stepDataDisplay = {};
                                $scope.globalVariable.drawStep();
                            }
                        });
                    }
                    else if (showType == "distance") {
                        $http.get('getData/patient?id='+ selectedPatientId).then(function(response){
                            $scope.globalVariable.selectedPatientAge = response.data.age;
                            $scope.globalVariable.selectedPatientFitBitId = response.data.fb_id;
                            $scope.globalVariable.selectedPatientGender = response.data.gender;
                            $scope.globalVariable.selectedPatientStartTime = response.data.enterDate.slice(0, 10);
                            $scope.globalVariable.selectedPatientCapability = response.data.capability;

                            $scope.globalVariable.distanceData = response.data.distanceData;
                            if($scope.globalVariable.distanceData && $scope.globalVariable.distanceData!={}){
                                $scope.globalVariable.endIndex = Object.keys($scope.globalVariable.distanceData).length - 1;
                                var distanceDataKeys = Object.keys($scope.globalVariable.stepData);
                                $scope.globalVariable.showNumber = 9;
                                $scope.globalVariable.dataNumber= distanceDataKeys.length;
                                if (distanceDataKeys.length < $scope.globalVariable.showNumber){
                                    $scope.globalVariable.startIndex = 0;
                                    $scope.globalVariable.distanceDataDisplay = $scope.globalVariable.distanceData;
                                }
                                else{
                                    var keysToShow = distanceDataKeys.sort().slice(-$scope.globalVariable.showNumber);
                                    $scope.globalVariable.distanceDataDisplay = {};
                                    $scope.globalVariable.startIndex = Object.keys($scope.globalVariable.distanceData).length - $scope.globalVariable.showNumber;
                                    keysToShow.forEach(function(item){
                                        $scope.globalVariable.distanceDataDisplay[item] = $scope.globalVariable.distanceData[item];
                                    });
                                }
                                $scope.globalVariable.drawDistance();
                            }
                            else{
                                $scope.globalVariable.distanceData = {};
                                $scope.globalVariable.distanceDataDisplay = {};
                                $scope.globalVariable.drawDistance();
                            }
                        });
                    }
                    else if (showType == "sleep") {
                        $http.get('/getData/patient?id='+selectedPatientId).then(function(response){
                            $scope.globalVariable.selectedPatientAge = response.data.age;
                            $scope.globalVariable.selectedPatientFitBitId = response.data.fb_id;
                            $scope.globalVariable.selectedPatientGender = response.data.gender;
                            $scope.globalVariable.selectedPatientStartTime = response.data.enterDate.slice(0, 10);
                            $scope.globalVariable.selectedPatientCapability = response.data.capability;

                            $scope.globalVariable.sleepData = response.data.sleepData;
                            if ($scope.globalVariable.sleepData && $scope.globalVariable.sleepData != {}){
                                $scope.globalVariable.sleepDatakeysInOrder = Object.keys($scope.globalVariable.sleepData).sort();
                                $scope.globalVariable.dataNumber = $scope.globalVariable.sleepDatakeysInOrder.length;
                                $scope.globalVariable.sleepDataIndexDisplayed = $scope.globalVariable.dataNumber - 1;
                                $scope.globalVariable.startIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                                $scope.globalVariable.endIndex = $scope.globalVariable.sleepDataIndexDisplayed;
                                $scope.globalVariable.sleepDatakeyDisplayed = $scope.globalVariable.sleepDatakeysInOrder[$scope.globalVariable.sleepDataIndexDisplayed];
                                $scope.globalVariable.sleepDataDisplayed = $scope.globalVariable.sleepData[$scope.globalVariable.sleepDatakeyDisplayed];
                                $scope.globalVariable.drawSleep();
                            }
                            else{
                                $scope.globalVariable.sleepData = {};
                                $scope.globalVariable.sleepDataDisplayed = {};
                                $scope.globalVariable.drawSleep();
                            }
                        });

                    }
                    else if (showType == "activity") {
                        $http.get('/getData/patient?id='+selectedPatientId).then(function(response){
                            $scope.globalVariable.selectedPatientAge = response.data.age;
                            $scope.globalVariable.selectedPatientFitBitId = response.data.fb_id;
                            $scope.globalVariable.selectedPatientGender = response.data.gender;
                            $scope.globalVariable.selectedPatientStartTime = response.data.enterDate.slice(0, 10);
                            $scope.globalVariable.selectedPatientCapability = response.data.capability;

                            $scope.globalVariable.activityData = response.data.activityData;
                            if ($scope.globalVariable.activityData && $scope.globalVariable.activityData != {}){
                                $scope.globalVariable.activityDatakeysInOrder = Object.keys($scope.globalVariable.activityData).sort();
                                $scope.globalVariable.dataNumber = $scope.globalVariable.activityDatakeysInOrder.length;
                                $scope.globalVariable.activityDataIndexDisplayed = $scope.globalVariable.dataNumber - 1;
                                $scope.globalVariable.startIndex = $scope.globalVariable.activityDataIndexDisplayed;
                                $scope.globalVariable.endIndex = $scope.globalVariable.activityDataIndexDisplayed;
                                $scope.globalVariable.activityDatakeyDisplayed = $scope.globalVariable.activityDatakeysInOrder[$scope.globalVariable.activityDataIndexDisplayed];
                                $scope.globalVariable.activityDataDisplayed = $scope.globalVariable.activityData[$scope.globalVariable.activityDatakeyDisplayed];
                                $scope.globalVariable.drawActivity();
                            }
                            else{
                                $scope.globalVariable.activityData = {};
                                $scope.globalVariable.activityDataDisplayed = {};
                                $scope.globalVariable.drawActivity();
                            }
                        });
                    }
                    else if (showType == "goals"){
                        $http.get('getData/patient?id='+selectedPatientId).then(function(response){
                           $scope.goals = response.data.goals;
                        });
                    }
                };
                $scope.endTreatment = function(id){
                    if (confirm("Are you sure to end the patient " + id + "'s treatment?")){
                        $http.post('postData/discharge', {id: id, therapyStatus: "discharged"}).then(function(response){
                            if(response.data === "ok"){
                                $scope.patientsDischargedDisplay[id] = true;
                                delete $scope.patientsInProgressDisplay[id];
                            }
                        });
                    }
                };
                $scope.deleteDischarged = function(id){
                    if(confirm("The patient: " + id + "'s record will be removed from database, are you sure to continue?")){
                        $http.post("postData/deletePatient", {id:id}).then(function(response){
                            if(response.data === "ok") {
                                delete $scope.patientsDischargedDisplay[id];
                                location.href = '/manage';
                            }
                        });
                    }
                };
                $scope.modifyCapability = function(id, newCapability){
                    $http.post('/postData/modifyCapability', {id:id, newCapability:newCapability}).then(function(response){
                        if(response.data==="ok"){
                            $scope.globalVariable.selectedPatientCapability = newCapability;
                            alert("successfully change the capability to: " + newCapability);
                        }
                    });
                };
            },
            controllerAs: 'sideNavBarCtrl'
        };
    });

})();