//
//  Character.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

// To be subclassed to create characters in the game
class Character: MovingEntity {
    
    var isAlive: Bool = true
    
    func injure() {
        die()
    }
    
    func die() {
        MVCManager.data.scene?.currentLevelMap?.removeEntity(self)
    }
    
}
