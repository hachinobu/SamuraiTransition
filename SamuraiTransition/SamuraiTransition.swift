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
    
    public var samuraiDelegate: SamuraiTransitionDelegate?
    
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
        let zanPoint = samuraiDelegate?.zanPosition ?? containerView.center
        
        let oneSideOffsetFrame: CGRect
        let otherSideOffsetFrame: CGRect
        let divided: (slice: CGRect, remainder: CGRect)
        let zanLine: UIView
        let zanEndPoint: CGSize
        
        if zanAngle.isHorizontal() {
            divided = containerFrame.divided(atDistance: zanPoint.y, from: .minYEdge)
            oneSideOffsetFrame = divided.slice.offsetBy(dx: 0.0, dy: -divided.slice.height)
            otherSideOffsetFrame = divided.remainder.offsetBy(dx: 0.0, dy: divided.remainder.height)
            
            zanLine = UIView(frame: CGRect(x: 0.0, y: zanPoint.y, width: 0.0, height: 1.0))
            zanEndPoint = CGSize(width: containerFrame.maxX, height: zanLine.frame.height)
        } else {
            divided = containerFrame.divided(atDistance: zanPoint.x, from: .minXEdge)
            oneSideOffsetFrame = divided.slice.offsetBy(dx: -divided.slice.width, dy: 0.0)
            otherSideOffsetFrame = divided.remainder.offsetBy(dx: divided.remainder.width, dy: 0.0)
            
            zanLine = UIView(frame: CGRect(x: zanPoint.x, y: 0.0, width: 1.0, height: 100.0))
            zanEndPoint = CGSize(width: zanLine.frame.width, height: containerFrame.maxY)
        }
        
        let oneSideView = zanTargetView.resizableSnapshotView(from: divided.slice, afterScreenUpdates: false, withCapInsets: .zero)!
        let otherSideView = zanTargetView.resizableSnapshotView(from: divided.remainder, afterScreenUpdates: false, withCapInsets: .zero)!
        
        containerView.addSubview(oneSideView)
        containerView.addSubview(otherSideView)
        
        if presenting {
            
            oneSideView.frame = divided.slice
            otherSideView.frame = divided.remainder
            containerView.insertSubview(toView, belowSubview: oneSideView)
            
            toView.alpha = 0.0
            if isAffineTransform {
                toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            coverView.frame = containerFrame
            containerView.insertSubview(coverView, belowSubview: toView)
            
            zanLine.backgroundColor = samuraiDelegate?.zanColor ?? .black
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
                oneSideView.frame = divided.slice
                otherSideView.frame = divided.remainder
            }, completion: { _ in
                self.toView.alpha = 1.0
                self.fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
        
    }
    
}
