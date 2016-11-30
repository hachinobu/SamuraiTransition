//
//  SamuraiTransition.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/11/26.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit

public class SamuraiTransition: NSObject {

    public var duration: TimeInterval = 0.33
    public var presenting = true
    public var zanAngle = ZanAngle.horizontal
    public var isAffineTransform: Bool = true
    public var zanPosition: CGPoint?
    public var zanLineColor = UIColor.black
    public var zanLineWidth: CGFloat = 0.3
    
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning!
    fileprivate var containerView: UIView!
    
    fileprivate var containerFrame: CGRect {
        return containerView.frame
    }
    
    fileprivate var toViewController: UIViewController {
        return transitionContext.viewController(forKey: .to)!
    }
    
    fileprivate var toView: UIView {
        return toViewController.view
    }
    
    fileprivate var fromViewController: UIViewController {
        return transitionContext.viewController(forKey: .from)!
    }
    
    fileprivate var fromView: UIView {
        return fromViewController.view
    }
    
    fileprivate let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    fileprivate var zanLineDuration: TimeInterval {
        let zanDuration = duration - 0.15
        if zanDuration > 0.0 {
            return 0.15
        }
        return 0.0
    }
    
}

extension SamuraiTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        containerView = transitionContext.containerView
        
        let zanTargetView = presenting ? fromView.snapshotView(afterScreenUpdates: false)! : toView.snapshotView(afterScreenUpdates: true)!
        let zanPoint = zanPosition ?? containerView.center
        
        let oneSideOffsetFrame: CGRect
        let otherSideOffsetFrame: CGRect
        let slice: CGRect
        let remainder: CGRect
        
        var oneSideMaskLayer: CAShapeLayer? = nil
        var otherSideMaskLayer: CAShapeLayer? = nil
        let lineLayer: CAShapeLayer
        
        if zanAngle.isHorizontal() {
            
            let divided = containerFrame.divided(atDistance: zanPoint.y, from: .minYEdge)
            slice = divided.slice
            remainder = divided.remainder
            oneSideOffsetFrame = slice.offsetBy(dx: 0.0, dy: -slice.height)
            otherSideOffsetFrame = remainder.offsetBy(dx: 0.0, dy: remainder.height)
            
            lineLayer = zanLineLayer(from: CGPoint(x: containerFrame.minX, y: zanPoint.y), end: CGPoint(x: containerFrame.maxX, y: zanPoint.y))
            
        } else if zanAngle.isVertical() {
            
            let divided = containerFrame.divided(atDistance: zanPoint.x, from: .minXEdge)
            slice = divided.slice
            remainder = divided.remainder
            oneSideOffsetFrame = slice.offsetBy(dx: -slice.width, dy: 0.0)
            otherSideOffsetFrame = remainder.offsetBy(dx: remainder.width, dy: 0.0)
            
            lineLayer = zanLineLayer(from: CGPoint(x: zanPoint.x, y: containerFrame.minY), end: CGPoint(x: zanPoint.x, y: containerFrame.maxY))
            
        } else {
            
            slice = containerFrame
            remainder = containerFrame
            oneSideOffsetFrame = slice.offsetBy(dx: slice.width, dy: slice.height)
            otherSideOffsetFrame = remainder.offsetBy(dx: -remainder.width, dy: -remainder.height)
            
            let maskLayers = maskLayer(zanPosition: zanPoint)
            oneSideMaskLayer = maskLayers.oneSide
            otherSideMaskLayer = maskLayers.otherSide
            
            let bottomX = diagnoallyBottomX(zanPosition: zanPoint)
            lineLayer = zanLineLayer(from: CGPoint(x: containerFrame.maxX, y: containerFrame.minY), end: CGPoint(x: bottomX, y: containerFrame.maxY))
            
        }
        
        let oneSideView = zanTargetView.resizableSnapshotView(from: slice, afterScreenUpdates: false, withCapInsets: .zero)!
        let otherSideView = zanTargetView.resizableSnapshotView(from: remainder, afterScreenUpdates: false, withCapInsets: .zero)!
        
        containerView.addSubview(oneSideView)
        oneSideView.layer.mask = oneSideMaskLayer
        
        containerView.addSubview(otherSideView)
        otherSideView.layer.mask = otherSideMaskLayer
        
        if presenting {
            
            oneSideView.frame = slice
            otherSideView.frame = remainder
            containerView.insertSubview(toView, belowSubview: oneSideView)
            
            toView.alpha = 0.0
            if isAffineTransform {
                toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            coverView.frame = containerFrame
            containerView.insertSubview(coverView, belowSubview: toView)
            
            containerView.layer.addSublayer(lineLayer)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                lineLayer.removeFromSuperlayer()
                UIView.animate(withDuration: self.duration - self.zanLineDuration, animations: {
                    
                    oneSideView.frame = oneSideOffsetFrame
                    otherSideView.frame = otherSideOffsetFrame
                    self.toView.alpha = 1.0
                    self.toView.transform = CGAffineTransform.identity
                    
                }, completion: { _ in
                    
                    oneSideView.removeFromSuperview()
                    otherSideView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                })
            }
            let animation = lineLayerAnimation(lineLayer: lineLayer)
            lineLayer.add(animation, forKey: nil)
            CATransaction.commit()
            
        } else {
            
            oneSideView.frame = oneSideOffsetFrame
            otherSideView.frame = otherSideOffsetFrame
            containerView.insertSubview(fromView, belowSubview: oneSideView)
            
            toView.alpha = 0.0
            UIView.animate(withDuration: duration, animations: {
                self.fromView.alpha = 0.0
                if self.isAffineTransform {
                    self.fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                oneSideView.frame = slice
                otherSideView.frame = remainder
            }, completion: { _ in
                self.toView.alpha = 1.0
                self.fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
        
    }
    
}

extension SamuraiTransition {
    
    fileprivate func lineLayerAnimation(lineLayer: CAShapeLayer) -> CABasicAnimation {
        
        let lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        lineAnimation.duration = zanLineDuration
        lineAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        lineAnimation.fromValue = 0.0
        lineAnimation.toValue = 1.0
        lineAnimation.fillMode = kCAFillModeForwards
        lineAnimation.isRemovedOnCompletion = false
        lineAnimation.setValue(lineLayer, forKey: "LineLayer")
        
        return lineAnimation
    }
    
    fileprivate func zanLineLayer(from start: CGPoint, end: CGPoint) -> CAShapeLayer {
        
        let zanLineLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        zanLineLayer.path = path.cgPath
        zanLineLayer.fillColor = nil
        zanLineLayer.strokeColor = zanLineColor.cgColor
        zanLineLayer.lineWidth = zanLineWidth
        return zanLineLayer
        
    }
    
    fileprivate func diagnoallyBottomX(zanPosition: CGPoint) -> CGFloat {
        
        let ratio = containerFrame.maxY / zanPosition.y
        if ratio.isInfinite {
            fatalError("zanPosition.y is not 0. It will be infinite.")
        }
        let width = (containerFrame.maxX - zanPosition.x) * ratio
        let bottomX = containerFrame.maxX - width
        
        return bottomX
    }
    
    fileprivate func maskLayer(zanPosition: CGPoint) -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let bottomX = diagnoallyBottomX(zanPosition: zanPosition)
        
        let oneSidePath = oneSideBezierPath(zanPosition: zanPosition, bottomX: bottomX)
        let oneSideLayer = CAShapeLayer()
        oneSideLayer.path = oneSidePath.cgPath
        
        let otherSidePath = otherSideBezierPath(zanPosition: zanPosition, bottomX: bottomX)
        let otherSideLayer = CAShapeLayer()
        otherSideLayer.path = otherSidePath.cgPath
        
        return (oneSideLayer, otherSideLayer)
    }
    
    private func oneSideBezierPath(zanPosition: CGPoint, bottomX: CGFloat) -> UIBezierPath {
        
        let oneSidePath = UIBezierPath()
        oneSidePath.move(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.addLine(to: zanPosition)
        oneSidePath.addLine(to: CGPoint(x: bottomX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.close()
        
        return oneSidePath
    }
    
    private func otherSideBezierPath(zanPosition: CGPoint, bottomX: CGFloat) -> UIBezierPath {
        
        let otherSidePath = UIBezierPath()
        otherSidePath.move(to: CGPoint(x: containerFrame.minX, y: containerFrame.minY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        otherSidePath.addLine(to: CGPoint(x: bottomX, y: containerFrame.maxY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.maxY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.minY))
        otherSidePath.close()
        
        return otherSidePath
    }
    
}
