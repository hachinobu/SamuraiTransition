# SamuraiTransition

SamuraiTransiton is a ViewController transition framework in Swift.

It is an animation as if Samurai cut out the screen with a sword.

![Demo](https://cloud.githubusercontent.com/assets/1317847/20857795/c7307784-b979-11e6-9f8c-1cd4ac1d66cd.gif)


# Usage
### Simple

```swift

// make your view controller a subclass of SamuraiViewController
// present it as normal

import SamuraiTransition

class ModalViewController: SamuraiViewController {
    //...
}

class ViewController: UIViewController {
    
    @IBAction func horizontalZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func verticalZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        // customization
        vc.samuraiTransition.zan = .vertical
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func diagonallyZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        // customization
        vc.samuraiTransition.zan = .diagonally
        present(vc, animated: true, completion: nil)
    }

}

```

### Attributes you can set

```swift
    //Time of transition
    public var duration: TimeInterval = 0.33
    //presenting or not
    public var presenting = true
    //horizontal　or vertical or diagonally
    public var zan = Zan.horizontal
    //enable or disable affine processing when ModalViewcontroller appears 
    public var isAffineTransform: Bool = true
    //Passing point of the sword line
    public var zanPoint: CGPoint?
    //sword line color
    public var zanLineColor = UIColor.black
    //sword line width
    public var zanLineWidth: CGFloat = 1.0

```

### Custom

```swift

class ViewController: UIViewController {
    
    let transition = SamuraiTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transition.duration = 1.0
        transition.zan = Zan.vertical
        transition.isAffineTransform = false
        transition.zanLineColor = .blue
        transition.zanLineWidth = 2.0
    }

    @IBAction func tapModalButton(_ sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        let button = sender as! UIButton
        transition.zanPoint = CGPoint(x: button.center.x, y: button.center.y)
//        vc.transitioningDelegate = transition
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }

}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}


```

# Requirements
* Xcode 8 or higher
* iOS 8.0 or higher
* Swift 3.0

# Installation
#### [CocoaPods](https://github.com/cocoapods/cocoapods)

`pod 'SamuraiTransition'`

# License
SamuraiTransiton is available under the MIT license. See the LICENSE file for more info.
