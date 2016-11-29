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
    public var zanLineWidth: CGFloat = 1.0
    
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
        let zanDuration = duration - 0.1
        if zanDuration >= 0.1 {
            return 0.1
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
        let zanLine: UIView
        let zanEndPoint: CGSize
        
        var oneSideMaskLayer: CAShapeLayer? = nil
        var otherSideMaskLayer: CAShapeLayer? = nil
        
        if zanAngle.isHorizontal() {
            let divided = containerFrame.divided(atDistance: zanPoint.y, from: .minYEdge)
            slice = divided.slice
            remainder = divided.remainder
            oneSideOffsetFrame = slice.offsetBy(dx: 0.0, dy: -slice.height)
            otherSideOffsetFrame = remainder.offsetBy(dx: 0.0, dy: remainder.height)
            
            zanLine = UIView(frame: CGRect(x: 0.0, y: zanPoint.y, width: 0.0, height: zanLineWidth))
            zanEndPoint = CGSize(width: containerFrame.maxX, height: zanLine.frame.height)
            
        } else if zanAngle.isVertical() {
            let divided = containerFrame.divided(atDistance: zanPoint.x, from: .minXEdge)
            slice = divided.slice
            remainder = divided.remainder
            oneSideOffsetFrame = slice.offsetBy(dx: -slice.width, dy: 0.0)
            otherSideOffsetFrame = remainder.offsetBy(dx: remainder.width, dy: 0.0)
            
            zanLine = UIView(frame: CGRect(x: zanPoint.x, y: 0.0, width: zanLineWidth, height: 0.0))
            zanEndPoint = CGSize(width: zanLine.frame.width, height: containerFrame.maxY)
        } else {
            slice = containerFrame
            remainder = containerFrame
            oneSideOffsetFrame = slice.offsetBy(dx: slice.width, dy: slice.height)
            otherSideOffsetFrame = remainder.offsetBy(dx: -remainder.width, dy: -remainder.height)
            
            zanLine = UIView(frame: CGRect(x: containerFrame.maxX, y: 0.0, width: 1.0, height: 1.0))
            zanEndPoint = .zero
            
            let maskLayers = maskLayer(zanPosition: zanPoint)
            oneSideMaskLayer = maskLayers.oneSide
            otherSideMaskLayer = maskLayers.otherSide
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
            
            zanLine.backgroundColor = zanLineColor
            containerView.addSubview(zanLine)
            
            UIView.animate(withDuration: zanLineDuration, animations: {
                zanLine.frame.size = zanEndPoint
            }, completion: { _ in
                
                zanLine.removeFromSuperview()
                
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
                
            })
            
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
    
    private func maskLayer(zanPosition: CGPoint) -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let oneSidePath = UIBezierPath()
        oneSidePath.move(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.addLine(to: zanPosition)
        let ratio = containerFrame.maxY / zanPosition.y
        if ratio.isInfinite {
            fatalError("zanPosition.y is not 0. It will be infinite.")
        }
        let width = (containerFrame.maxX - zanPosition.x) * ratio
        let bottomX = containerFrame.maxX - width
        
        oneSidePath.addLine(to: CGPoint(x: bottomX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.close()
        let oneSideLayer = CAShapeLayer()
        oneSideLayer.path = oneSidePath.cgPath
        
        let otherSidePath = UIBezierPath()
        otherSidePath.move(to: CGPoint(x: containerFrame.minX, y: containerFrame.minY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        otherSidePath.addLine(to: CGPoint(x: bottomX, y: containerFrame.maxY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.maxY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.minY))
        otherSidePath.close()
        
        let otherSideLayer = CAShapeLayer()
        otherSideLayer.path = otherSidePath.cgPath
        
        return (oneSideLayer, otherSideLayer)
    }
    
}
