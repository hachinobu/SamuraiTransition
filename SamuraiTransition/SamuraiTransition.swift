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
    
}

extension SamuraiTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        containerView = transitionContext.containerView
        
        if presenting {
            
            let zanTargetView = fromView.snapshotView(afterScreenUpdates: false)!
            let zanPoint = containerView.center
            let oneSideSnapFrame: CGRect
            let otherSideSnapFrame: CGRect
            
            let oneSideFinishFrame: CGRect
            let otherSideFnishFrame: CGRect
            
            if zanAngle.isHorizontal() {
                let divided = containerFrame.divided(atDistance: zanPoint.y, from: .minYEdge)
                oneSideSnapFrame = divided.slice
                otherSideSnapFrame = divided.remainder
                oneSideFinishFrame = oneSideSnapFrame.offsetBy(dx: 0.0, dy: -oneSideSnapFrame.height)
                otherSideFnishFrame = otherSideSnapFrame.offsetBy(dx: 0.0, dy: otherSideSnapFrame.height)
            } else {
                let divided = containerFrame.divided(atDistance: zanPoint.x, from: .minXEdge)
                oneSideSnapFrame = divided.slice
                otherSideSnapFrame = divided.remainder
                oneSideFinishFrame = oneSideSnapFrame.offsetBy(dx: -oneSideSnapFrame.width, dy: 0.0)
                otherSideFnishFrame = otherSideSnapFrame.offsetBy(dx: otherSideSnapFrame.width, dy: 0.0)
            }
            
            let oneSideView = zanTargetView.resizableSnapshotView(from: oneSideSnapFrame, afterScreenUpdates: false, withCapInsets: .zero)!
            oneSideView.frame = oneSideSnapFrame
            
            let otherSideView = zanTargetView.resizableSnapshotView(from: otherSideSnapFrame, afterScreenUpdates: false, withCapInsets: .zero)!
            otherSideView.frame = otherSideSnapFrame
            
            containerView.addSubview(oneSideView)
            containerView.addSubview(otherSideView)
            containerView.insertSubview(toView, belowSubview: oneSideView)
            toView.alpha = 0.3
            toView.transform = CGAffineTransform(scaleX: 0.4, y: 0.3)
            
            let blackView = UIView(frame: containerFrame)
            blackView.backgroundColor = .black
            containerView.insertSubview(blackView, belowSubview: toView)
            
//            let oneSideViewAnimation = CABasicAnimation(keyPath: "position")
//            oneSideViewAnimation.duration = duration
//            oneSideViewAnimation.toValue = NSValue(cgPoint: oneSideFinishFrame.origin)
            
            UIView.animate(withDuration: duration, animations: { 
                oneSideView.frame = oneSideFinishFrame
                otherSideView.frame = otherSideFnishFrame
                self.toView.alpha = 1.0
                self.toView.transform = CGAffineTransform.identity
            }, completion: { _ in
                oneSideView.removeFromSuperview()
                otherSideView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        } else {
            
            let zanTargetView = toView.snapshotView(afterScreenUpdates: true)!
            let zanPoint = containerView.center
            
            let oneSideSnapFrame: CGRect
            let otherSideSnapFrame: CGRect
            
            let oneSideFinishFrame: CGRect
            let otherSideFnishFrame: CGRect
            
            if zanAngle.isHorizontal() {
                let divided = containerFrame.divided(atDistance: zanPoint.y, from: .minYEdge)
                oneSideSnapFrame = divided.slice
                otherSideSnapFrame = divided.remainder
                oneSideFinishFrame = oneSideSnapFrame.offsetBy(dx: 0.0, dy: -oneSideSnapFrame.height)
                otherSideFnishFrame = otherSideSnapFrame.offsetBy(dx: 0.0, dy: otherSideSnapFrame.height)
            } else {
                let divided = containerFrame.divided(atDistance: zanPoint.x, from: .minXEdge)
                oneSideSnapFrame = divided.slice
                otherSideSnapFrame = divided.remainder
                oneSideFinishFrame = oneSideSnapFrame.offsetBy(dx: -oneSideSnapFrame.width, dy: 0.0)
                otherSideFnishFrame = otherSideSnapFrame.offsetBy(dx: otherSideSnapFrame.width, dy: 0.0)
            }
            
            let oneSideView = zanTargetView.resizableSnapshotView(from: oneSideSnapFrame, afterScreenUpdates: false, withCapInsets: .zero)!
            oneSideView.frame = oneSideFinishFrame
            
            let otherSideView = zanTargetView.resizableSnapshotView(from: otherSideSnapFrame, afterScreenUpdates: false, withCapInsets: .zero)!
            otherSideView.frame = otherSideFnishFrame
            
            containerView.addSubview(fromView)
            containerView.addSubview(oneSideView)
            containerView.addSubview(otherSideView)
            toView.alpha = 0.0
            
            UIView.animate(withDuration: duration, animations: {
                self.fromView.alpha = 0.0
                self.fromView.transform = CGAffineTransform(scaleX: 0.4, y: 0.3)
                oneSideView.frame = oneSideSnapFrame
                otherSideView.frame = otherSideSnapFrame
            }, completion: { _ in
                self.toView.alpha = 1.0
                self.fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
        
    }
    
}
