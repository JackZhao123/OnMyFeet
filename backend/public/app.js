/**
 * Created by zhaosiyang on 2016-03-03.
 */
(function() {
    var app = angular.module('dashboard', ['directives']);
    app.factory('globalVariable', function(){
        return {"test":"Kern"};
    });
    google.charts.load('current', {packages: ['corechart', 'bar']});

    app.controller("coreDataAreaCtrl", function(globalVariable){
        this.globalVariable = globalVariable;
        this.globalVariable.showType = null;
        var _this = this;

        this.globalVariable.drawStep = function() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Date');
            data.addColumn('number', 'Steps');
            var dateInOrder = Object.keys(_this.globalVariable.stepDataDisplay).sort();
            for (var i in dateInOrder){
                data.addRow([dateInOrder[i].slice(5), _this.globalVariable.stepDataDisplay[dateInOrder[i]]]);
            }
            var options = {
                title: 'Daily data of walked steps',
                hAxis: {
                    title: 'Date',
                    format: 'MMM-dd'
                },
                vAxis: {
                    title: 'Steps walked'
                },
                height: 300,
                width: 1000,
                is3D: true
            };
            var chart = new google.visualization.ColumnChart(
                document.getElementById('stepChart'));
            chart.draw(data, options);
        };

        this.globalVariable.drawDistance = function() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Date');
            data.addColumn('number', 'distance');
            var dateInOrder = Object.keys(_this.globalVariable.distanceDataDisplay).sort();
            for (var i in dateInOrder){
                data.addRow([dateInOrder[i].slice(5), _this.globalVariable.distanceDataDisplay[dateInOrder[i]]]);
                //console.log(date.slice(5));
            }
            var options = {
                title: 'Daily data of walked distance (meter)',
                hAxis: {
                    title: 'Date',
                    format: 'MMM-dd'
                },
                vAxis: {
                    title: 'Distance walked'
                },
                height: 300,
                width: 1000,
                is3D: true
            };
            var chart = new google.visualization.ColumnChart(
                document.getElementById('distanceChart'));
            chart.draw(data, options);
        };

        this.globalVariable.drawSleep = function() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Time');
            data.addColumn('number', 'Disturbance');
            data.addColumn({type: 'string', role: 'tooltip'});

            var keysInOrder = Object.keys(_this.globalVariable.sleepDataDisplayed).sort();
            var len = keysInOrder.length;
            var drawAtIndex = [0, Math.floor(len / 4) , Math.floor(len / 2), Math.floor(len / 4) * 3, len-1];
            console.log("drawAtIndex: ");
            console.log(drawAtIndex);
            for (var i in keysInOrder){
                if (drawAtIndex.indexOf(i)>=0){
                    console.log("into it");
                    data.addRow([keysInOrder[i], _this.globalVariable.sleepDataDisplayed[keysInOrder[i]], keysInOrder[i]]);
                }
                else{
                    data.addRow(["", _this.globalVariable.sleepDataDisplayed[keysInOrder[i]], keysInOrder[i]]);
                }
            }
            var options = {
                title: 'One Time Sleep Data Since: ' + _this.globalVariable.sleepDatakeyDisplayed,
                hAxis: {
                    title: 'Time',
                    //format: 'hh:mm:ss'
                },
                vAxis: {
                    title: 'Disturbance'
                },
                height: 300,
                width: 1000,
                is3D: true
            };
            var chart = new google.visualization.ColumnChart(
                document.getElementById('sleepChart'));
            chart.draw(data, options);
        };

        this.globalVariable.drawActivity = function() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Time');
            data.addColumn('number', 'Active');
            data.addColumn({type: 'string', role: 'tooltip'});
            data.addColumn('number', 'Semi-active');
            data.addColumn({type: 'string', role: 'tooltip'});
            data.addColumn('number', 'Sedentary');
            data.addColumn({type: 'string', role: 'tooltip'});

            var time_array = Object.keys(_this.globalVariable.activityDataDisplayed).sort();
            var len = time_array.length;
            time_array.push("24:00");


            for (var i=0; i<len; i++){
                var new_row = _this.globalVariable.activityDataDisplayed[time_array[i]].slice();
                var time = time_array[i];
                var next_time = time_array[i+1];
                new_row.splice(3, 0, time+"-"+next_time+"\nSedentary: "+_this.globalVariable.activityDataDisplayed[time][2]);
                new_row.splice(2, 0, time+"-"+next_time+"\nSemi-Active: "+_this.globalVariable.activityDataDisplayed[time][1]);
                new_row.splice(1, 0, time+"-"+next_time+"\nActive: "+_this.globalVariable.activityDataDisplayed[time][0]);
                if(time === "00:00" || time === "06:00" || time === "12:00" || time === "18:00" || time === "23:00" ){
                    var _time = time;
                }
                else{
                    _time = ""
                }
                new_row.splice(0, 0, _time);
                data.addRow(new_row);
            }
            var options = {
                title: 'Activity Data for Date: ' + _this.globalVariable.activityDatakeyDisplayed,
                hAxis: {
                    title: 'time'
                },
                vAxis: {
                    title: 'Activity Level'
                },
                height: 300,
                width: 1000,
                is3D: true,
                isStacked: true
            };
            var chart = new google.visualization.ColumnChart(
                document.getElementById('activityChart'));
            chart.draw(data, options);

        };

        google.charts.setOnLoadCallback(this.drawAll);

        this.globalVariable.drawAll = function(){
            this.globalVariable.drawStep();
            this.globalVariable.drawDistance();
            this.globalVariable.drawSleep();
            this.globalVariable.drawActivity();
        };
    });

})();