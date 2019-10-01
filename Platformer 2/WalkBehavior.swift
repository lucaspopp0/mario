//
//  WalkBehavior.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

enum WalkDirection {
    
    case none
    case left
    case right
    
}

protocol Walking {
    
    var walkDirection: WalkDirection { get set }
    var walkSpeed: CGFloat { get set }
    
    func walkLeft()
    
    func walkRight()
    
    func walkNone()
    
}

// Default MovementBehavior for walking
class WalkBehavior: MovementBehavior {
    
    override func applyBehavior(timeStep: CGFloat) {
        super.applyBehavior(timeStep: timeStep)
        
        if entity is Walking {
            var walkingEntity: Walking = entity as! Walking
            
            if walkingEntity.walkDirection == WalkDirection.right {
                let walkStep: CGFloat = walkingEntity.walkSpeed * timeStep
                
                entity.velocity.x += walkStep
            } else if walkingEntity.walkDirection == WalkDirection.left {
                let walkStep: CGFloat = walkingEntity.walkSpeed * timeStep
                
                entity.velocity.x -= walkStep
            }
            
            entity.velocity.x *= 0.9
        }
    }
    
}
