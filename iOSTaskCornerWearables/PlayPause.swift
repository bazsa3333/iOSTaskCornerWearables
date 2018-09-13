//
//  PlayPause.swift
//  iOSTaskCornerWearables
//
//  Created by Bálint Németh on 2018. 09. 12..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class PlayPause: UIButton {

    let playImage = UIImage(named: "PlayBtn")
    let pauseImage = UIImage(named: "PauseBtn")
    
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!

    var counter = 0
    var min = 0
    var timer = Timer()
    
    var isPlaying: Bool = false {
        
        didSet{
            
            if isPlaying == true {
                self.setImage(pauseImage, for: UIControlState.normal)
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            } else {
                
                self.setImage(playImage, for: UIControlState.normal)
                timer.invalidate()
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isPlaying = false
    }
    
    @objc func buttonClicked(sender: UIButton){
        
        if sender == self {
            
            isPlaying = !isPlaying
        }
    }
    
    @objc func timerAction() {
        
        if counter < 60 {
            
            counter += 1
            secLabel.text = String(format: "%02d", counter)
        } else {
            
            counter = 1
            min += 1
            secLabel.text = String(format: "%02d", counter)
            minLabel.text = String(min)
        }
    }
}
