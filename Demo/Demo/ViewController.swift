//
//  ViewController.swift
//  Demo
//
//  Created by Chandan Karmakar on 22/01/21.
//

import UIKit
import LucidAnimationsSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var box2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.arrangedSubviews.forEach({ $0.transform = .init(translationX: 100, y: 0) })
        
        lucid.set(duration: 2.0).anim { self.stackView.arrangedSubviews[0].transform = .identity }
        lucid.set(delay: 3.0).set(duration: 0.7).set(bounce: true).serially(count: stackView.arrangedSubviews.count, interval: 0.2) { i in
            self.stackView.arrangedSubviews[i].transform = .identity
        }
        lucid.execute()
    }

    @IBAction func actionButton() {
        if box.isHidden {
            lucid.flat { self.box.isHidden = false }
            lucid.anim { self.view.layoutIfNeeded() }
            lucid.set(bounce: true).set(duration: 1.0).anim { self.box.alpha = 1; self.box.transform = .identity }
            lucid.execute()
        } else {
            lucid.set(duration: 2.0).anim { self.box.alpha = 0; self.box.transform = .init(translationX: 200, y: 0) }
            lucid.flat { self.box.isHidden = true }
            lucid.anim { self.view.layoutIfNeeded() }
            lucid.execute()
        }
    }
    
    lazy var rotateAnim: LucidAnim = {
        let rotateAnim = LucidAnim()
        rotateAnim.set(duration: 0.5).anim { self.box2.transform = .init(rotationAngle: -CGFloat.pi / 4) }
        rotateAnim.set(duration: 0.5).anim { self.box2.transform = .init(rotationAngle: CGFloat.pi) }
        rotateAnim.set(duration: 0.5).anim { self.box2.layer.cornerRadius = self.box2.bounds.height / 2 }
        rotateAnim.set(duration: 0.5).anim { self.box2.layer.cornerRadius = 0 }
        return rotateAnim
    }()
    
    @IBAction func actionAnimation2() {
        rotateAnim.execute()
    }
}

