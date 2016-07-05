//
//  DownloadButton.swift
//  DownloadButton
//
//  Created by Zhicong Zang on 7/5/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

@IBDesignable
class DownloadButton: UIView {
    
    static let defaultFillColor = UIColor.clearColor()
    static let defaultLineColor = UIColor.blackColor()
    static let defaultLineWidth: CGFloat = 3.0
    
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
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
    
    var progress: Float = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        fillColor = DownloadButton.defaultFillColor
        lineColor = DownloadButton.defaultLineColor
        lineWidth = DownloadButton.defaultLineWidth
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fillColor = DownloadButton.defaultFillColor
        lineColor = DownloadButton.defaultLineColor
        lineWidth = DownloadButton.defaultLineWidth
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func setup() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: -CGFloat(M_PI / 2.0), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = fillColor.CGColor
        circleLayer.strokeColor = lineColor.CGColor
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 0
        layer.addSublayer(circleLayer)
    }
    
    func updateProgress() {
        circleLayer.strokeEnd = min(max(CGFloat(progress),0.0), 1.0)
    }

}
