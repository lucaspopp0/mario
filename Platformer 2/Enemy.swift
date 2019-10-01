//
//  Enemy.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/28/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class Enemy: Character {
    
    override init(image: UIImage, position: CGPoint) {
        super.init(image: image, position: position)
        
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func die() {
        isAlive = false
        
        super.die()
    }
    
}
