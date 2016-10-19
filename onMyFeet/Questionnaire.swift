//
//  Questionnaire.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-10.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

class Questionnaire: NSObject, NSCoding {
    var testEntry:String
    var numberOfValue:Int
    var onlyTextEnable = false
    var labelDic:[Int:String]?
    var questionSet:[String]
    
    required init?(coder aDecoder: NSCoder) {
        
        let testEntry = aDecoder.decodeObject(forKey: "testEntry") as? String
        let numberOfValue = aDecoder.decodeInteger(forKey: "numberOfValue") as Int?
        let onlyTextEnable = aDecoder.decodeBool(forKey: "onlyTextEnable") as Bool?
        let labelDic = aDecoder.decodeObject(forKey: "labelDic") as? [Int:String]
        let questionSet = aDecoder.decodeObject(forKey: "questionSet") as? [String]
        
        self.testEntry = testEntry!
        self.numberOfValue = numberOfValue!
        self.onlyTextEnable = onlyTextEnable!
        self.labelDic = labelDic
        self.questionSet = questionSet!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.testEntry, forKey: "testEntry")
        aCoder.encode(self.numberOfValue, forKey: "numberOfValue")
        aCoder.encode(onlyTextEnable, forKey: "onlyTextEnable")
        aCoder.encode(labelDic, forKey: "labelDic")
        aCoder.encode(questionSet, forKey: "questionSet")
        
    }
    
    override init() {
        testEntry = "Something Wrong"
        numberOfValue = 10
        labelDic = [Int:String]()
        questionSet = [String]()
    }

}

class QuestionnaireSample {
    var ser:Questionnaire!
    var stai:Questionnaire!
    var abc:Questionnaire!
    var cesd:Questionnaire!
    
    init() {
        ser = Questionnaire()
        ser.testEntry = "During my rehabilitation,\nI believe I can do..."
        ser.numberOfValue = 11
        ser.labelDic = [0:"I cannot do it", 10:"I can do it"]
        ser.questionSet = ["Therapy that requires me to stretch my leg", "Therapy that requires me to lift my leg ", "Therapy that requires me to bend my leg", "Therapy that requires me to stand", "Therapy that requires me to walk", "All of my therapy exercises during my rehabilitation","My therapy every day that it is scheduled", "The exercises my therapists say I should do, even if I don’t understand how it helps me","My therapy no matter how I feel emotionally","My therapy no matter how tired I may feel", "My therapy even though I may already have other complicating illnesses", "My therapy regardless of the amount of pain I am feeling"]
        
        stai = Questionnaire()
        stai.testEntry = "Indicate how you feel right now,\nthat is , at this moment"
        stai.numberOfValue = 4
        stai.labelDic = [0:"Not at all", 1:"Somewhat", 2:"Moderately so" , 3:"Very Much so"]
        stai.questionSet = ["I feel calm", "I feel strained", "I feel at ease", "I am presently worrying over possible misfortunes", "I feel indecisive","I feel satisfied","I feel nervous","I feel frightened","I feel content","I feel self-confident"]

        abc = Questionnaire()
        abc.testEntry = "How confident are you that you could perform the following, without feeling unsteady, losing your balance or falling?"
        abc.numberOfValue = 11
        abc.labelDic = [0:"No Confidence", 10:"Completely confident"]
        abc.questionSet = ["Walking around the house","Walking up and down the stairs inside your home","Bend over and pick up a slipper from the front of a closet floor","Reach for a small can off a shelf that is at eye level","Stand on your tip toes and reach for something above your head", "Stand on a chair and reach for something", "Sweeping the floor","Walking outside of the house to the car that is parked in the driveway","Getting into or out of the car","Walking across the parking lot to the mall", "Walking up or down a ramp", "Walking in a crowded mall where people are rapidly walking towards you and pass you by", "People bumping in to you as you walk through the mall", "Stepping onto or off an escalator while holding onto the railing", "Stepping onto or off an escalator while holding onto parcels such that you cannot hold on to the railing", "Walking outside on icy sidewalks"]

        cesd = Questionnaire()
        cesd.testEntry = "Below is a list of the ways you might have felt or behaved. Please tell me how often you have felt this way during the past week"
        cesd.numberOfValue = 4
        cesd.onlyTextEnable = true
        cesd.labelDic = [0:"Less than 1 day", 1:"1-2 days", 2:"3-4 days", 3:"5-7 days"]
        cesd.questionSet = ["I was bothered by things that usually don’t bother me","I did not feel like eating; my appetite was poor","I felt that I could not shake off the blues even with help from my family or friends","I felt I was just as good as other people","I had trouble keeping my mind on what I was doing","I felt depressed","I felt that everything I did was an effort","I felt hopeful about the future","I thought my life had been a failure","I felt fearful","My sleep was restless", "I was happy", "I talked less than usual","I felt lonely","People were unfriendly","I enjoyed life","I had crying spells","I felt sad","I felt that people dislike me","I could not get going"]
        
    }
}
