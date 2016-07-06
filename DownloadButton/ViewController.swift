//
//  ViewController.swift
//  DownloadButton
//
//  Created by Zhicong Zang on 7/5/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var downloadButton: DownloadButton!
    
    var timer: NSTimer?
    
    
    var progress: Float = 0 {
        didSet {
            downloadButton.setProgress(progress)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloadButton.addTarget(self, action: #selector(ViewController.p), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func addProgress() {
        progress += 0.02
    }
    
    func p() {
        if downloadButton.buttonState == DownloadButtonState.Paused {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.addProgress), userInfo: nil, repeats: true)
            downloadButton.startProgressing()
        } else if downloadButton.buttonState == DownloadButtonState.Downloading {
            timer?.invalidate()
            downloadButton.pauseProgressing()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

