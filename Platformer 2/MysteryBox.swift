//
//  MysteryBox.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/9/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class MysteryBox: Block {
    
    var isEmpty: Bool = false {
        didSet {
            updateSprite()
        }
    }
    
    var animationSprites: [UIImage] = []
    var usedSprite: UIImage!
    
    override func updateSprite() {
        super.updateSprite()
        
        if isEmpty {
            displaySprite(usedSprite)
        } else {
            displaySprite(animationSprite(spriteTime: MVCManager.data.universalSpriteIndex, sprites: animationSprites, frameTime: 0.25))
        }
    }
    
    override func spitItem(toMap map: LevelMap) {
        super.spitItem(toMap: map)
        
        if contents.count == 0 {
            isEmpty = true
        }
    }
    
    override func dropItem(toMap map: LevelMap) {
        super.dropItem(toMap: map)
        
        if contents.count == 0 {
            isEmpty = true
        }
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        updateSprite()
    }
    
}
