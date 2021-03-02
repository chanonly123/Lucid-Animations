//
//  ViewController.swift
//  Demo
//
//  Created by Chandan Karmakar on 22/01/21.
//

import UIKit
import LucidAnimationsSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var box2: UIView!
    
    let colors: [UIColor] = [.init(hex: "#55efc4"), .init(hex: "#81ecec"), .init(hex: "#74b9ff"), .init(hex: "#a29bfe"), .init(hex: "#fab1a0"), .init(hex: "#e17055")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self; tableView.dataSource = self
        collectionView.delegate = self; collectionView.dataSource = self
        
        stackView.arrangedSubviews.forEach({ $0.transform = .init(translationX: 100, y: 0) })
        
        let lucid = LucidAnim()
        lucid.set(duration: 2.0).anim { self.stackView.arrangedSubviews[0].transform = .identity }
        lucid.set(delay: 3.0).set(duration: 0.7).set(bounce: true).serially(count: stackView.arrangedSubviews.count, interval: 0.2) { i in
            self.stackView.arrangedSubviews[i].transform = .identity
        }
        lucid.execute()
        
//        DispatchQueue.main.async {
//            let lucid = LucidAnim()
//            let cells = self.tableView.visibleCells.sorted(by: { self.tableView.indexPath(for: $0)!.row < self.tableView.indexPath(for: $1)!.row })
//            cells.forEach { $0.transform = .init(translationX: 0, y: 20); $0.alpha = 0 }
//            lucid.set(duration: 0.15).serially(count: cells.count, interval: 0.06, anim: {
//                cells[$0].transform = .identity; cells[$0].alpha = 1
//            })
//            lucid.execute()
//        }
//
//        DispatchQueue.main.async {
//            let lucid = LucidAnim()
//            let cells = self.collectionView.visibleCells.sorted(by: { $0.frame.origin.y < $1.frame.origin.y })
//            cells.forEach { $0.transform = .init(translationX: 0, y: 20); $0.alpha = 0 }
//            lucid.set(duration: 0.15).serially(count: cells.count, interval: 0.06, anim: {
//                cells[$0].transform = .identity; cells[$0].alpha = 1
//            })
//            lucid.execute()
//        }
    }


    @IBAction func actionButton() {
        let lucid = LucidAnim()
        if box.isHidden {
            lucid.flat { self.box.isHidden = false }
            lucid.anim { self.view.layoutIfNeeded() }
            lucid.set(bounce: true).set(duration: 1.0).anim { self.box.alpha = 1; self.box.transform = .identity }
            lucid.execute()
        } else {
            lucid.set(duration: 2.1).anim { self.box.alpha = 0; self.box.transform = .init(translationX: 200, y: 0) }
            lucid.flat { self.box.isHidden = true }
            lucid.anim { self.view.layoutIfNeeded() }
            lucid.execute()
        }
    }
    
    lazy var rotateAnim: LucidAnim = {
        let rotateAnim = LucidAnim(.init(duration: 0.5))
        rotateAnim.anim { self.box2.transform = .init(rotationAngle: -CGFloat.pi / 4) }
        rotateAnim.anim { self.box2.transform = .init(rotationAngle: CGFloat.pi) }
        rotateAnim.anim { self.box2.layer.cornerRadius = self.box2.bounds.height / 2 }
        rotateAnim.anim { self.box2.layer.cornerRadius = 0 }
        return rotateAnim
    }()
    
    @IBAction func actionAnimation2() {
        rotateAnim.execute()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row % colors.count]
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        cell.backgroundColor = colors[indexPath.row % colors.count]
        return cell
    }
}

class TableCell: UITableViewCell {
        
}

class CollectionCell: UICollectionViewCell {
        
}

extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.count != 6 {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
