//
//  DownloadButton.swift
//  DownloadButton
//
//  Created by Zhicong Zang on 7/5/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit


let playImage = UIImage(named: "Play")
let stopImage = UIImage(named: "Stop")
let downloadImage = UIImage(named: "Download")
let deleteImage = UIImage(named: "Delete")

enum DownloadButtonState {
    case Paused
    case Downloading
    case Downloaded
}

@IBDesignable
class DownloadButton: UIControl {
    
    static let defaultFillColor = UIColor.clearColor()
    static let defaultLineColor = UIColor.blackColor()
    static let defaultLineWidth: CGFloat = 3.0
    static let defaultImageZoom: CGFloat = 0.6
    
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
    private var imageLayer: CALayer = CALayer()
    
    @IBInspectable
    var fillColor: UIColor = UIColor.clearColor() {
        didSet {
            circleLayer.fillColor = fillColor.CGColor
        }
    }
    
    @IBInspectable
    var lineColor: UIColor = UIColor.blackColor() {
        didSet {
            circleLayer.strokeColor = lineColor.CGColor
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 3.0 {
        didSet {
            circleLayer.lineWidth = lineWidth
        }
    }
    
    @IBInspectable
    var imageZoom: CGFloat = 0.8 {
        didSet {
            imageZoom = min(max(0.0, imageZoom), 1.0)
            imageLayer.frame = CGRect(x: frame.size.width * (1 - imageZoom) / 2, y: frame.size.height * (1 - imageZoom) / 2, width: frame.size.width * imageZoom, height: frame.size.height * imageZoom)
        }
    }
    
    private(set) var buttonState: DownloadButtonState = .Paused {
        didSet {
            if oldValue != buttonState {
                dispatch_async(dispatch_get_main_queue(), {
                    switch self.buttonState {
                    case .Paused:
                        self.circleLayer.hidden = true
                        self.imageLayer.contents = downloadImage?.CGImage
                    case .Downloading:
                        self.circleLayer.hidden = false
                        self.imageLayer.contents = stopImage?.CGImage
                    case .Downloaded:
                        self.circleLayer.hidden = true
                        self.imageLayer.contents = playImage?.CGImage
                        
                    }
                })
                
            }
        }
    }
    
    private var progress: Float = 0 {
        didSet {
            if oldValue != progress && progress < 1.0 {
                updateProgress(fromValue: oldValue, toValue: progress)
            }
            if progress == 1.0{
                completeProgressing()
            }
        }
    }
    
    private var animated: Bool = true
    
    override init(frame: CGRect) {
        fillColor = DownloadButton.defaultFillColor
        lineColor = DownloadButton.defaultLineColor
        lineWidth = DownloadButton.defaultLineWidth
        imageZoom = DownloadButton.defaultImageZoom
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fillColor = DownloadButton.defaultFillColor
        lineColor = DownloadButton.defaultLineColor
        lineWidth = DownloadButton.defaultLineWidth
        imageZoom = DownloadButton.defaultImageZoom
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func setup() {
        imageLayer.contents = downloadImage?.CGImage
        layer.addSublayer(imageLayer)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - lineWidth)/2, startAngle: -CGFloat(M_PI / 2.0), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = fillColor.CGColor
        circleLayer.strokeColor = lineColor.CGColor
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 0
        layer.addSublayer(circleLayer)
        
        
        self.addTarget(self, action: #selector(DownloadButton.touchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: #selector(DownloadButton.touchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: #selector(DownloadButton.touchUp(_:)), forControlEvents: UIControlEvents.TouchDragExit)
    }
    
    func setProgress(progress: Float) {
        self.progress = min(max(progress,0.0), 1.0)
    }
    
    private func updateProgress(fromValue fromValue: Float, toValue: Float) {
        if animated {
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.15
            if circleLayer.animationKeys()?.count > 0 {
                animation.fromValue = circleLayer.presentationLayer()!.strokeEnd
                circleLayer.strokeEnd = circleLayer.presentationLayer()!.strokeEnd
                circleLayer.removeAllAnimations()
            } else {
                animation.fromValue = CGFloat(fromValue)
            }
            
            animation.toValue = CGFloat(toValue)
            circleLayer.addAnimation(animation, forKey: "strokeEnd")
            CATransaction.commit()
        }
        
    }
    
    @objc private func touchDown(sender: DownloadButton) {
        self.animated = false
        self.touchDownAnimationWithScaleFactor(xScaleFactor: 0.8, yScaleFactor: 0.8, duration: 0.05)
    }
    
    @objc private func touchUp(sender: DownloadButton) {
        self.touchUpAnimation(duration: 0.05)
    }
    
    func completeProgressing() {
        buttonState = .Downloaded
    }
    
    func startProgressing() {
        buttonState = .Downloading
    }
    
    func pauseProgressing() {
        buttonState = .Paused
    }
    
}



extension DownloadButton {
    private func touchDownAnimationWithScaleFactor(xScaleFactor xScaleFactor: CGFloat, yScaleFactor: CGFloat, duration: CFTimeInterval) {
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.transform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
            self.alpha = 0.8
            }, completion: nil)
    }
    private func touchUpAnimation(duration duration: CFTimeInterval) {
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.transform = CGAffineTransformMakeScale(1, 1)
            self.alpha = 1
            }, completion: {_ in self.animated = true})
    }
}




















