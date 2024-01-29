//
//  UIView+Ext.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit.UIView

public extension UIView {
    func round(
        _ corners: UIRectCorner = .allCorners,
        radii: CGFloat = 16.0
    ) {
        let cornerRadii = CGSize(width: radii, height:  radii)
        
        let path = UIBezierPath(
            roundedRect:self.bounds,
            byRoundingCorners:corners,
            cornerRadii: cornerRadii
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func animateBounce(
        with duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        springDampingValue: Double = 0.2,
        initialSpringVelocity: Double = 6.0,
        scalePoint: CGPoint = .init(x: 0.98, y: 0.98),
        animationOptions: UIView.AnimationOptions = .allowUserInteraction
    ) {
        transform = CGAffineTransform(scaleX: scalePoint.x, y: scalePoint.y)
        UIView.animate(
            withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: springDampingValue,
                       initialSpringVelocity: initialSpringVelocity,
                       options: animationOptions
        ) { [weak self] in
            self?.transform = .identity
        }
    }
    
    @discardableResult
    func applyShadow(
        _ color: UIColor = .black,
        alpha: Float = 0.25,
        xOffset: CGFloat = 0,
        yOffset: CGFloat = 2,
        blur: CGFloat = 10,
        spread: CGFloat = 0
    ) -> Self {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        layer.shadowRadius = blur / 2.0
        
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let newRect = bounds.insetBy(dx: -spread, dy: -spread)
            layer.shadowPath = UIBezierPath(rect: newRect).cgPath
        }
        
        return self
    }
}
