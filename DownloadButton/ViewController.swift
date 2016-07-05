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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.addProgress), userInfo: nil, repeats: true)
    }
    
    func addProgress() {
        downloadButton.progress += 0.02
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

