//
//  Bush.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/5/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class Bush: Entity {
    
    var animationSprites: [UIImage]!
    
    init(sprites: [UIImage], position: CGPoint) {
        super.init(image: sprites[0], position: position)
        
        animationSprites = sprites
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateSprite() {
        super.updateSprite()
        
        displaySprite(animationSprite(
            spriteTime: MVCManager.data.universalSpriteIndex,
            sprites: animationSprites,
            frameTime: 1))
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        updateSprite()
    }
    
}
