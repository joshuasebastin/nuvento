//
//  CustomLoader.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation
import UIKit

class LoaderView: UIView {

    private let loaderLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoader()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoader()
    }

    private func setupLoader() {
        let loaderSize: CGFloat = 50
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: loaderSize / 2, y: loaderSize / 2),
                                        radius: loaderSize / 2,
                                        startAngle: 0,
                                        endAngle: .pi * 2,
                                        clockwise: true)

        loaderLayer.path = circularPath.cgPath
        loaderLayer.strokeColor = UIColor.blue.cgColor
        loaderLayer.lineWidth = 4
        loaderLayer.fillColor = UIColor.clear.cgColor
        loaderLayer.lineCap = .round
        loaderLayer.strokeStart = 0
        loaderLayer.strokeEnd = 0.75  // Partial circle to create the "gap"
        
        self.layer.addSublayer(loaderLayer)
        
        startRotating()
    }
    
    private func startRotating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity
        
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    func showIndicator(view:UIViewController){
        let loaderView = LoaderView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loaderView.center = view.view.center
        view.view.addSubview(loaderView)
    }
}
