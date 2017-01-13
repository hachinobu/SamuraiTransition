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
    public var operation: UINavigationControllerOperation! {
        didSet {
            popOperation = operation == .pop
        }
    }
    
    fileprivate var popOperation: Bool = false
    
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning!
    fileprivate var containerView: UIView!
    
    fileprivate var containerFrame: CGRect {
        return containerView.frame
    }
    
    fileprivate var toViewController: UIViewController {
        return transitionContext.viewController(forKey: .to)!
    }
    
    fileprivate var toView: UIView {
        return transitionContext.view(forKey: .to)!
    }
    
    fileprivate var fromViewController: UIViewController {
        return transitionContext.viewController(forKey: .from)!
    }
    
    fileprivate var fromView: UIView {
        return transitionContext.view(forKey: .from)!
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
        
        coverView.frame = containerFrame
        containerView.addSubview(coverView)
        
        let point = zanPoint ?? containerView.center
        let samuraiConfig = zan.samuraiConfig(containerFrame: containerFrame, zanPoint: point, lineWidth: zanLineWidth, lineColor: zanLineColor)
        
        if presenting {
            
            containerView.addSubview(toView)
            
            let zanViews = samuraiConfig.zanViewConfigList.map {
                fromView.snapshotView(rect: $0.inSideFrame, afterScreenUpdate: false)!
            }
            
            zip(zanViews, samuraiConfig.zanViewConfigList).forEach { (view, config) in
                containerView.addSubview(view)
                view.frame = config.viewFrame(isPresenting: presenting)
                view.layer.mask = config.mask
            }
            
            toView.alpha = 0.0
            if isAffineTransform {
                toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                samuraiConfig.lineLayers.forEach { $0.removeFromSuperlayer() }
                UIView.animate(withDuration: self.duration - self.zanLineDuration, animations: {
                    
                    zip(zanViews, samuraiConfig.zanViewConfigList).forEach { (view, config) in
                        view.frame = config.outSideFrame
                        view.alpha = config.isAlphaAnimation ? 0.0 : 1.0
                    }
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
            
            containerView.bringSubview(toFront: fromView)
            containerView.addSubview(toView)
            
            let zanViews = samuraiConfig.zanViewConfigList.map {
                toView.snapshotView(rect: $0.inSideFrame, afterScreenUpdate: !popOperation)!
            }
            
            zip(zanViews, samuraiConfig.zanViewConfigList).forEach { (view, config) in
                containerView.addSubview(view)
                view.frame = config.viewFrame(isPresenting: presenting)
                view.layer.mask = config.mask
            }
            
            toView.isHidden = true
            UIView.animate(withDuration: duration, animations: {
                
                self.fromView.alpha = 0.0
                if self.isAffineTransform {
                    self.fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                zip(zanViews, samuraiConfig.zanViewConfigList).forEach { $0.0.frame = $0.1.inSideFrame }
                
            }, completion: { _ in
                
                self.toView.isHidden = false
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

extension SamuraiTransition: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = operation == .push
        self.operation = operation
        return self
    }
    
}
