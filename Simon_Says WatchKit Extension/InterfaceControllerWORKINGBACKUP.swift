//
//  InterfaceController.swift
//  Simon_Says WatchKit Extension
//
//  Created by Eric Peterson on 11/9/18.
//  Copyright © 2018 Eric Peterson. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var counter = 0.0
    var timer = Timer()
    var isPlaying = false
    var start = DispatchTime.now()
    var end = DispatchTime.now()
    var beat = Beats()
    var beatPattern = [Double]()
    var userReply = [Double]()
    var beatStore = [Double]()
    var tapCount = 0
    var level = 1
    
    struct MyVariables {
        static var beatPattern = [Double]()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    @IBAction func Start() {
        
        MyVariables.beatPattern = beat.makeBeat(level: level)
        //
        print(MyVariables.beatPattern)
        isPlaying = false
        
        userReply = [Double]()
        start = DispatchTime.now()
        end = DispatchTime.now()
        tapCount = MyVariables.beatPattern.count
        
        sleep(1)
        
        for i in 0 ... (MyVariables.beatPattern.count - 1) {
            WKInterfaceDevice.current().play(.start)
            usleep(useconds_t(MyVariables.beatPattern[i]))
            print(MyVariables.beatPattern[i])
        }
       
    }
    
    @IBAction func tap() {
        
        let time = recordTime(state: isPlaying)
        isPlaying = false
        
        if (time != 0.0 && tapCount > 0)
        {
            WKInterfaceDevice.current().play(.start)
            userReply.append(time)
            print(time)
            tapCount = tapCount - 1
            
            if(tapCount == 0){     //Compute Score
                
//                score.setText("lvl 3 ❌✅")

                print(MyVariables.beatPattern)
                print(userReply)
                
                if(beat.getScore(orginal: MyVariables.beatPattern, user: userReply)){
                    level = level + 1
                    score.setText("   lvl \(level) ✅")
                    
                }
                
                else{
                    level = 1
                    score.setText("   lvl \(level) ❌")
                    

                    

                }
                
            }
        }
        
        else{
            isPlaying = false
        }
        
    }
    
    func recordTime(state: Bool) -> Double{
        if state{
            start = DispatchTime.now() // <<<<<<<<<< Start time
            return 0.0
        }
        
        else{
            end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
            start = DispatchTime.now() // <<<<<<<<<< Start time
            return timeInterval * 1000000
        }
    }
    
    @IBOutlet weak var score: WKInterfaceLabel!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        score.setText("   lvl 1")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

}



}
