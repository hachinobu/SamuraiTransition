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
    
    @IBOutlet weak var zanSliderX: UISlider!
    @IBOutlet weak var zanSliderY: UISlider!
    @IBOutlet weak var zanLabelX: UILabel!
    @IBOutlet weak var zanLabelY: UILabel!
    var zanPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Samurai Transition"
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        
        zanSliderX.minimumValue = 0.0
        zanSliderX.maximumValue = Float(view.frame.maxX)
        zanSliderX.setValue(Float(view.frame.midX), animated: true)
        zanSliderX.addTarget(self, action: #selector(changeSliderXValue(sender:)), for: .valueChanged)
        zanLabelX.text = zanSliderX.value.description
        
        zanSliderY.minimumValue = 0.0
        zanSliderY.maximumValue = Float(view.frame.maxY)
        zanSliderY.setValue(Float(view.frame.midY), animated: true)
        zanSliderY.addTarget(self, action: #selector(changeSliderYValue(sender:)), for: .valueChanged)
        zanLabelY.text = zanSliderY.value.description
        
        zanPoint = view.center
    }
    
    func changeSliderXValue(sender: UISlider) {
        zanLabelX.text = sender.value.description
        zanPoint.x = CGFloat(sender.value)
    }
    
    func changeSliderYValue(sender: UISlider) {
        zanLabelY.text = sender.value.description
        zanPoint.y = CGFloat(sender.value)
    }
    
    @IBAction func horizontalZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        navigationController?.delegate = vc.samuraiTransition
        vc.samuraiTransition.zan = .horizontal
        vc.samuraiTransition.zanPoint = zanPoint
        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func verticalZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .vertical
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func diagonallyZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .diagonally
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func crossZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .cross
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func xZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .x
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func jaggedZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .jagged(width: 5.0)
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func circleZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .circle(radius: 50.0)
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func rectangleZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .rectangle(width: 100.0, height: 100.0, cornerRadius: 5.0)
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func triangleZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        vc.samuraiTransition.zan = .triangle(oneSide: 200.0)
        vc.samuraiTransition.zanPoint = zanPoint
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func shreddedZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        navigationController?.delegate = vc.samuraiTransition
        vc.samuraiTransition.zan = .shredded(isHorizontal: true, shreddedCount: 30)
        present(vc, animated: true)
    }
    

}
