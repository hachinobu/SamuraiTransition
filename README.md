![SamuraiTransition](https://cloud.githubusercontent.com/assets/1317847/21515399/a0b30e80-cd12-11e6-9170-fb61c0143c17.png)


SamuraiTransiton is a ViewController transition framework in Swift.

It is an animation as if Samurai cut out the screen with a sword.

# transition types

|horizontal|vertical|diaonally|cross|
|:--:|:--:|:--:|:--:|
|![horizontalzan](https://user-images.githubusercontent.com/1317847/59350691-ad428600-8d57-11e9-80c5-3099d0d50cad.gif)|![vertical](https://user-images.githubusercontent.com/1317847/59350728-ccd9ae80-8d57-11e9-9290-ab0a7ec39a09.gif)|![diagonally](https://user-images.githubusercontent.com/1317847/59350753-dc58f780-8d57-11e9-932f-8a364288ba9b.gif)|![cross](https://user-images.githubusercontent.com/1317847/59350768-e2e76f00-8d57-11e9-95c1-561a4b1c0d3c.gif)|

|x|jagged|circle|rectangle|
|:--:|:--:|:--:|:--:|
|![x](https://user-images.githubusercontent.com/1317847/59350778-e8dd5000-8d57-11e9-892d-8b3fd7908436.gif)|![jagged](https://user-images.githubusercontent.com/1317847/59350777-e8dd5000-8d57-11e9-87f5-76f80acc134b.gif)|![circle](https://user-images.githubusercontent.com/1317847/59350779-e8dd5000-8d57-11e9-8e02-c73906579d2d.gif)|![rectangle](https://user-images.githubusercontent.com/1317847/59350780-e8dd5000-8d57-11e9-9433-c971529bac8e.gif)|

|triangle|shredded|chopped|
|:--:|:--:|:--:|
|![triangle](https://user-images.githubusercontent.com/1317847/59350781-e975e680-8d57-11e9-8e0e-0d44641d878c.gif)|![shredded](https://user-images.githubusercontent.com/1317847/59350792-eda20400-8d57-11e9-9fa1-630793735446.gif)|![chopped](https://user-images.githubusercontent.com/1317847/59350795-eda20400-8d57-11e9-9a2a-a69113f8324f.gif)|




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
* Xcode 10 or higher
* iOS 9.0 or higher
* Swift 5.0

# Installation
#### [CocoaPods](https://github.com/cocoapods/cocoapods)

`pod 'SamuraiTransition'`

#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "hachinobu/SamuraiTransition"`
- Run `carthage update`.
- Link your app with `SamuraiTransition.framework` in `Carthage/Build`.

# License
SamuraiTransiton is available under the MIT license. See the LICENSE file for more info.
