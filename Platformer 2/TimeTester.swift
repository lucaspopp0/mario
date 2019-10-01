//
//  TimeTester.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/14/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import Foundation

class TimeTester {
    
    internal static var nextId: Int = 0
    
    static var runTimes: [String: [TimeInterval]] = [:]
    
    static var timeTests: [Int: (name: String, startTime: Date)] = [:]
    
    static func beginTest(name: String) -> Int {
        timeTests[nextId] = (name: name, startTime: Date())
        
        nextId += 1
        
        return nextId - 1
    }
    
    static func finishedExecuting(testId: Int) {
        let finishDate: Date = Date()
        
        if let test = timeTests[testId] {
            let time: TimeInterval = finishDate.timeIntervalSince(test.startTime)
            
            if runTimes[test.name] == nil {
                runTimes[test.name] = [time]
            } else {
                runTimes[test.name]!.append(time)
            }
        }
    }
    
    static func clearTimesFor(name: String) {
        if runTimes[name] != nil {
            runTimes[name]! = []
        }
    }
    
    static func averageFor(name: String) -> String {
        if runTimes[name] != nil {
            var sum: Double = 0
            
            for time: Double in runTimes[name]! {
                sum += time
            }
            
            return "AVG \(name): \((sum / Double(runTimes[name]!.count)) * 1000)ms"
        }
        
        return ""
    }
    
}
