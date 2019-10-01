//
//  MovementBehavior.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

// Handles movement for moving entities
class MovementBehavior: NSObject {
    
    // A reference to the entity the instance is controlling
    var entity: MovingEntity!
    
    init(entity: MovingEntity) {
        self.entity = entity
    }
    
    // Called in MovingEntity.update(timeStep:) to perform behavior
    func applyBehavior(timeStep: CGFloat) {}
    
}
