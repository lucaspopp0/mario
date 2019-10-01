//
//  BounceBehavior.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

protocol Bouncing {
    
    var bounceSpeed: CGFloat { get set }
    
    func bounced()
    
}

// Default MovementBehavior for bouncing
class BounceBehavior: MovementBehavior {
    
    var lastOnGround: Bool = true
    
    override func applyBehavior(timeStep: CGFloat) {
        super.applyBehavior(timeStep: timeStep)
        
        var bouncingEntity: Bouncing = entity as! Bouncing
        
        if entity.onGround {
            entity.velocity.y = bouncingEntity.bounceSpeed
            
            if !lastOnGround {
                bouncingEntity.bounced()
            }
        }
        
        lastOnGround = entity.onGround
    }
    
}
