//
//  SignatureView.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 17/02/24.
//

import UIKit

class SignatureView: UIView {

    private var strokeColor = UIColor.black
    private var strokeWidth: CGFloat = 2
    private var path = UIBezierPath()
    private var touchPoints = [CGPoint]()

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.backgroundColor = UIColor(red: 181/255, green: 183/255, blue: 189/255, alpha: 0.7)
        self.isMultipleTouchEnabled = false
        path.lineWidth = strokeWidth
        self.layer.cornerRadius = 8
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let startPoint = touch.location(in: self)
        path.move(to: startPoint)
        touchPoints.append(startPoint)
    }
    
    func hasSignature() -> Bool {
            return !touchPoints.isEmpty
        }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        path.addLine(to: currentPoint)
        touchPoints.append(currentPoint)
        self.setNeedsDisplay()
    }

 
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        path.stroke()
    }

    func clear() {
        path.removeAllPoints()
        touchPoints.removeAll()
        setNeedsDisplay()
    }
}
