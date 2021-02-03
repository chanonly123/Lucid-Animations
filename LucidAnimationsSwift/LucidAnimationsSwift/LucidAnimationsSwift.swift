//
//  LucidAnimationsSwift.swift
//  LucidAnimationsSwift
//
//  Created by Chandan Karmakar on 22/01/21.
//

import UIKit

public struct LucidAnimValues: Equatable {
    
    public init(duration: Double = 0.3, delay: Double = 0.3, options: UIView.AnimationOptions = [], bounce: Bool = false, damping: CGFloat = 0.5, velocity: CGFloat = 0.0) {
        self.duration = duration
        self.delay = delay
        self.options = options
        self.bounce = bounce
        self.damping = damping
        self.velocity = velocity
    }
    
    var anim: Any = {} // (()->Void) or ((Int)->Void)
    
    var animated: Bool = true
    
    //
    public var duration: Double = 0.3
    
    //
    public var delay: Double = 0.3
    
    //
    public var options: UIView.AnimationOptions = []
    
    //
    public var bounce: Bool = false
    
    // usingSpringWithDamping
    public var damping: CGFloat = 0.5
    
    // initialSpringVelocity
    public var velocity: CGFloat = 0.0
    
    // view index for sequential view animations
    var viewIndex = 0
    
    func callAnimClosure() {
        if let anim = anim as? (() -> Void) {
            anim()
        } else if let anim = anim as? ((Int) -> Void) {
            anim(viewIndex)
        }
    }
    
    func isSerialAnim() -> Bool {
        return anim is ((Int) -> Void)
    }
    
    public static func == (lhs: LucidAnimValues, rhs: LucidAnimValues) -> Bool {
        return lhs.animated == rhs.animated &&
            lhs.delay == rhs.delay &&
            lhs.options == rhs.options &&
            lhs.bounce == rhs.bounce &&
            lhs.damping == rhs.damping &&
            lhs.velocity == rhs.velocity &&
            lhs.viewIndex == rhs.viewIndex
    }
}

public class LucidAnim {
    var queue = [LucidAnimValues]()
    var backupQueue = [LucidAnimValues]()
    lazy var currentValues = defaultValues
    var isTesting = false
    
    public var defaultValues = LucidAnimValues()
    
    public init() {}
    
    public init(_ defaultValues: LucidAnimValues) {
        self.defaultValues = defaultValues
    }
    
    public func clear() {
        queue.removeAll()
        backupQueue.removeAll()
        currentValues = defaultValues
    }
    
    public func flat(comp: @escaping (() -> Void)) {
        currentValues.animated = false
        currentValues.anim = comp
        
        backupQueue.append(currentValues)
        currentValues = defaultValues
    }
    
    public func anim(anim: @escaping (() -> Void)) {
        currentValues.animated = true
        currentValues.anim = anim
        
        backupQueue.append(currentValues)
        currentValues = defaultValues
    }
    
    public func serially(count: Int, interval: Double, anim: @escaping ((Int) -> Void)) {
        currentValues.animated = true
        currentValues.anim = anim
        
        for i in 0 ..< count {
            if i > 0 {
                currentValues.delay = Double(i) * interval
            }
            currentValues.viewIndex = i
            currentValues.animated = true
            currentValues.anim = anim
            backupQueue.append(currentValues)
        }
        currentValues = defaultValues
    }
    
    public func execute() {
        queue.removeAll()
        queue.append(contentsOf: backupQueue)
        execute_()
    }

    func execute_() {
        if let each = queue.first {
            queue.removeFirst()
            if each.animated {
                let shouldRunSerial = (queue.first?.isSerialAnim() ?? false) && each.isSerialAnim()
                
                let animation: (() -> Void) = {
                    each.callAnimClosure()
                }
                
                let animEnd: ((Bool) -> Void) = { finished in
                    if !finished { return }
                    if !shouldRunSerial {
                        self.execute_()
                    }
                }
                
                if isTesting {
                    animation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + each.duration + each.delay) {
                        animEnd(true)
                    }
                } else {
                    if each.bounce {
                        UIView.animate(withDuration: each.duration, delay: each.delay, usingSpringWithDamping: each.damping, initialSpringVelocity: each.velocity, options: each.options, animations: animation, completion: animEnd)
                    } else {
                        UIView.animate(withDuration: each.duration, delay: each.delay, options: each.options, animations: animation, completion: animEnd)
                    }
                }
                
                if shouldRunSerial {
                    self.execute_()
                }
            } else {
                each.callAnimClosure()
                self.execute_()
            }
        }
    }
    
    // MARK: getter and setters

    public func set(duration: Double) -> Self {
        currentValues.duration = duration
        return self
    }
    
    public func set(delay: Double) -> Self {
        currentValues.delay = delay
        return self
    }
    
    public func set(options: UIView.AnimationOptions) -> Self {
        currentValues.options = options
        return self
    }
    
    public func set(bounce: Bool) -> Self {
        currentValues.bounce = bounce
        return self
    }
    
    public func set(damping: CGFloat) -> Self {
        currentValues.damping = damping
        return self
    }
    
    public func set(velocity: CGFloat) -> Self {
        currentValues.velocity = velocity
        return self
    }
}
