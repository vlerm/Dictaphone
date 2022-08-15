//
//  VoiceRecord.swift
//  Dictaphone
//
//  Created by Вадим Лавор on 14.08.22.
//

import UIKit

@IBDesignable
class VoiceRecord: UIView {
    
    @IBInspectable var rate: CGFloat = Double()
    
    @IBInspectable var fillColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var image: UIImage! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named: "Microphone")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        image = UIImage(named: "Microphone")
    }
    
    func update(_ rate: CGFloat) {
        self.rate = rate
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let graphicsGetCurrentContext = UIGraphicsGetCurrentContext()
        graphicsGetCurrentContext?.translateBy(x: 0, y: bounds.size.height)
        graphicsGetCurrentContext?.scaleBy(x: 1, y: -1)
        graphicsGetCurrentContext?.draw(image.cgImage!, in: bounds)
        graphicsGetCurrentContext?.clip(to: bounds, mask: image.cgImage!)
        graphicsGetCurrentContext?.setFillColor(fillColor.cgColor.components!)
        graphicsGetCurrentContext?.fill(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * rate))
    }
    
    override func prepareForInterfaceBuilder() {
        let bundle = Bundle(for: type(of: self))
        image = UIImage(named: "Microphone", in: bundle, compatibleWith: self.traitCollection)
    }
    
}
