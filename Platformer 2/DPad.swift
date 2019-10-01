//
//  DPad.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/3/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

enum DPadDirection {
    
    case none
    case up
    case right
    case down
    case left
    
}

class DPad: SKSpriteNode {
    
    internal let shape: SKShapeNode = SKShapeNode()
    
    var currentDirection: DPadDirection = DPadDirection.none
    var previousDirection: DPadDirection = DPadDirection.none
    
    internal var changeTargets: [AnyObject] = []
    internal var changeActions: [Selector] = []
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        addChild(shape)
        
        isUserInteractionEnabled = true
        
        let pegWidth: CGFloat = min(size.width, size.height) * 0.3
        
        let mutablePath: CGMutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: pegWidth / 2, y: pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: size.width / 2, y: pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: size.width / 2, y: -pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: pegWidth / 2, y: -pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: pegWidth / 2, y: -size.height / 2))
        mutablePath.addLine(to: CGPoint(x: -pegWidth / 2, y: -size.height / 2))
        mutablePath.addLine(to: CGPoint(x: -pegWidth / 2, y: -pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: -size.width / 2, y: -pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: -size.width / 2, y: pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: -pegWidth / 2, y: pegWidth / 2))
        mutablePath.addLine(to: CGPoint(x: -pegWidth / 2, y: size.height / 2))
        mutablePath.addLine(to: CGPoint(x: pegWidth / 2, y: size.height / 2))
        mutablePath.addLine(to: CGPoint(x: pegWidth / 2, y: pegWidth / 2))
        
        shape.path = mutablePath
        shape.fillColor = UIColor(white: 0.3, alpha: 1)
        shape.strokeColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addChangeTarget(_ target: AnyObject, with action: Selector) {
        changeTargets.append(target)
        changeActions.append(action)
    }
    
    func removeChangeTarget(_ target: AnyObject, with action: Selector) {
        for i in 0 ..< changeTargets.count {
            if changeTargets[i].isEqual(target) && changeActions[i] == action {
                changeTargets.remove(at: i)
                changeActions.remove(at: i)
                break
            }
        }
    }
    
    func removeAllChangeTargets() {
        changeTargets.removeAll()
        changeActions.removeAll()
    }
    
    func triggerEvents() {
        for i in 0 ..< changeTargets.count {
            let _ = changeTargets[i].perform(changeActions[i])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let location: CGPoint = touches.first!.location(in: self)
        
        var newDirection: DPadDirection = DPadDirection.none
        
        if location.x > 0 && location.x > abs(location.y) {
            newDirection = DPadDirection.right
        } else if location.x < 0 && abs(location.x) > abs(location.y) {
            newDirection = DPadDirection.left
        } else if location.y > 0 && location.y > abs(location.x) {
            newDirection = DPadDirection.up
        } else if location.y < 0 && abs(location.y) > abs(location.x) {
            newDirection = DPadDirection.down
        }
        
        if newDirection != currentDirection {
            previousDirection = currentDirection
            currentDirection = newDirection
            
            triggerEvents()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let location: CGPoint = touches.first!.location(in: self)
        
        var newDirection: DPadDirection = DPadDirection.none
        
        if location.x > 0 && location.x > abs(location.y) {
            newDirection = DPadDirection.right
        } else if location.x < 0 && abs(location.x) > abs(location.y) {
            newDirection = DPadDirection.left
        } else if location.y > 0 && location.y > abs(location.x) {
            newDirection = DPadDirection.up
        } else if location.y < 0 && abs(location.y) > abs(location.x) {
            newDirection = DPadDirection.down
        }
        
        if newDirection != currentDirection {
            previousDirection = currentDirection
            currentDirection = newDirection
            
            triggerEvents()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        previousDirection = currentDirection
        currentDirection = DPadDirection.none
        
        triggerEvents()
    }
    
}
