//
//  ViewController.swift
//  Example
//
//  Created by Takahiro Nishinobu on 2016/11/26.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import SamuraiTransition

class ViewController: UIViewController {

    let samuraiTransition = SamuraiTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        samuraiTransition.zanAngle = .diagonally
        samuraiTransition.isAffineTransform = true
        samuraiTransition.duration = 0.33
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func zanAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }

}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        samuraiTransition.presenting = true
        return samuraiTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        samuraiTransition.presenting = false
        return samuraiTransition
    }
    
}
