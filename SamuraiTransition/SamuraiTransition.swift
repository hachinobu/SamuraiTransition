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
    public var zan = Zan.horizontal
    public var isAffineTransform: Bool = true
    public var zanPoint: CGPoint?
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
        let zanDuration = duration - 0.16
        if zanDuration > 0.0 {
            return 0.16
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
        let point = zanPoint ?? containerView.center
        
        let samuraiConfig = zan.samuraiConfig(containerFrame: containerFrame, zanPoint: point, width: zanLineWidth, color: zanLineColor)
        let zanViews = samuraiConfig.zanViewConfigList.map { zanTargetView.resizableSnapshotView(from: $0.insideFrame, afterScreenUpdates: false, withCapInsets: .zero)! }
        
        coverView.frame = containerFrame
        containerView.addSubview(coverView)
        
        zip(zanViews, samuraiConfig.zanViewConfigList).forEach { (view, config) in
            containerView.addSubview(view)
            view.frame = config.viewFrame(isPresenting: presenting)
            view.layer.mask = config.mask
        }
        
        if presenting {
            
            containerView.insertSubview(toView, aboveSubview: coverView)
            toView.alpha = 0.0
            if isAffineTransform {
                toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                samuraiConfig.lineLayers.forEach { $0.removeFromSuperlayer() }
                UIView.animate(withDuration: self.duration - self.zanLineDuration, animations: {
                    
                    zip(zanViews, samuraiConfig.zanViewConfigList).forEach { $0.0.frame = $0.1.outSideFrame }
                    self.toView.alpha = 1.0
                    self.toView.transform = CGAffineTransform.identity
                    
                }, completion: { _ in
                    
                    zanViews.forEach { $0.removeFromSuperview() }
                    self.coverView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                })
            }
            
            samuraiConfig.lineLayers.forEach { lineLayer in
                containerView.layer.addSublayer(lineLayer)
                let animation = lineLayerAnimation()
                lineLayer.add(animation, forKey: nil)
            }
            
            CATransaction.commit()
            
        } else {
            
            containerView.insertSubview(fromView, aboveSubview: coverView)
            containerView.addSubview(toView)
            toView.alpha = 0.0
            
            UIView.animate(withDuration: duration, animations: {
                
                self.fromView.alpha = 0.0
                if self.isAffineTransform {
                    self.fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                zip(zanViews, samuraiConfig.zanViewConfigList).forEach { $0.0.frame = $0.1.insideFrame }
                
            }, completion: { _ in
                
                self.toView.alpha = 1.0
                self.fromView.removeFromSuperview()
                self.coverView.removeFromSuperview()
                zanViews.forEach { $0.removeFromSuperview() }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            })
            
        }
        
    }
    
}

extension SamuraiTransition {
    
    fileprivate func lineLayerAnimation() -> CABasicAnimation {
        
        let lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        lineAnimation.duration = zanLineDuration
        lineAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        lineAnimation.fromValue = 0.0
        lineAnimation.toValue = 1.0
        lineAnimation.fillMode = kCAFillModeForwards
        lineAnimation.isRemovedOnCompletion = false
        
        return lineAnimation
    }
    
}

extension SamuraiTransition: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}

