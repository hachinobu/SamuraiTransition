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
    
}

extension SamuraiTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        containerView = transitionContext.containerView
        
        let zanTargetView = presenting ? fromView.snapshotView(afterScreenUpdates: false)! : toView.snapshotView(afterScreenUpdates: true)!
        let zanPoint = containerView.center
        
        let oneSideOffsetFrame: CGRect
        let otherSideOffsetFrame: CGRect
        let divided: (slice: CGRect, remainder: CGRect)
        
        if zanAngle.isHorizontal() {
            divided = containerFrame.divided(atDistance: zanPoint.y, from: .minYEdge)
            oneSideOffsetFrame = divided.slice.offsetBy(dx: 0.0, dy: -divided.slice.height)
            otherSideOffsetFrame = divided.remainder.offsetBy(dx: 0.0, dy: divided.remainder.height)
        } else {
            divided = containerFrame.divided(atDistance: zanPoint.x, from: .minXEdge)
            oneSideOffsetFrame = divided.slice.offsetBy(dx: -divided.slice.width, dy: 0.0)
            otherSideOffsetFrame = divided.remainder.offsetBy(dx: divided.remainder.width, dy: 0.0)
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
            toView.transform = CGAffineTransform(scaleX: 0.4, y: 0.3)
            
            coverView.frame = containerFrame
            containerView.insertSubview(coverView, belowSubview: toView)
            
            UIView.animate(withDuration: duration, animations: {
                oneSideView.frame = oneSideOffsetFrame
                otherSideView.frame = otherSideOffsetFrame
                self.toView.alpha = 1.0
                self.toView.transform = CGAffineTransform.identity
            }, completion: { _ in
                oneSideView.removeFromSuperview()
                otherSideView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        } else {
            
            oneSideView.frame = oneSideOffsetFrame
            otherSideView.frame = otherSideOffsetFrame
            containerView.insertSubview(fromView, belowSubview: oneSideView)
            
            toView.alpha = 0.0
            UIView.animate(withDuration: duration, animations: {
                self.fromView.alpha = 0.0
                self.fromView.transform = CGAffineTransform(scaleX: 0.4, y: 0.3)
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
