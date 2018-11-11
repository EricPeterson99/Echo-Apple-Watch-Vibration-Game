//
//  Beat.swift
//  Simon_Says WatchKit Extension
//
//  Created by Eric Peterson on 11/9/18.
//  Copyright © 2018 Eric Peterson. All rights reserved.
//

import Foundation

class Beats  {

    var maxBeats: Int = 5;
    
    // Default Constructor (No parameter)
    // (Used to create instance).
    init()  {
        
    }
    
    
    init (maxBeats: Int)  {
        self.maxBeats = maxBeats
        
    }
    func makeBeat(level : Int)  -> [Double]  {

        maxBeats = 2 + (level/2) //Always 2 beats or more
        var timeBetweenBeats = [Double]()
        
        for _ in 1 ... maxBeats {
            timeBetweenBeats.append(Double(
                100000 * ((Int.random(in: 5 ... 10 )))))   //One second time modifier, makes half beat to beat and quater rest. Also too one second/10
        }
        return timeBetweenBeats
    }
    
    func getScore(orginal: [Double], user: [Double]) -> Bool{
        
        for i in 1 ... (user.count - 1) {
            
            let score = 1-(user[i]/orginal[i])          //calculates percent error
            
            print("This is score \(i) | \(score)")
    
            if(score < -0.6 || score > 0.6){          //Each beat passes if the percent error is between 0 and 60%
                return false    //fail
            }
        }
        return true     //pass to next level
        
    }
    
    
}

