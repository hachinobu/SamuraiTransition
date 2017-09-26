//
//  SamuraiViewController.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/12/03.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit

open class SamuraiViewController: UIViewController {

    public lazy var samuraiTransition: SamuraiTransition = {
        let transition = SamuraiTransition()
        transition.duration = 0.33
        transition.isAffineTransform = true
        transition.zan = .horizontal
        transition.zanLineColor = .black
        return transition
    }()
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        transitioningDelegate = samuraiTransition
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupDismissView()
    }
    
    open func setupDismissView() {
        
        let dismissView = UIView()
        dismissView.translatesAutoresizingMaskIntoConstraints = false
        dismissView.backgroundColor = .clear
        view.insertSubview(dismissView, at: 0)
        view.addConstraints([NSLayoutAttribute.top, .left, .right, .bottom].map {
            NSLayoutConstraint(item: dismissView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1.0, constant: 0.0)
        })
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDismissView))
        dismissView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc open func tapDismissView() {
        dismiss(animated: true, completion: nil)
    }

}
