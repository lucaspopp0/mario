//
//  StarCoin.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/17/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class StarCoin: Item {
    
    var sound: Sound?
    
    var sprites: [UIImage] = []
    
    var useTime: CGFloat?
    
    init(position: CGPoint = CGPoint.zero) {
        super.init(image: #imageLiteral(resourceName: "Star Coin 1"), position: position)
        
        sprites = [#imageLiteral(resourceName: "Star Coin 1"), #imageLiteral(resourceName: "Star Coin 2"), #imageLiteral(resourceName: "Star Coin 3"), #imageLiteral(resourceName: "Star Coin 4"), #imageLiteral(resourceName: "Star Coin 5")]
        
        affectedByGravity = false
        collidesWithLevel = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadSounds(manager: SoundManager) {
        sound = manager.loadSound(url: SoundManager.urls["Star Coin"]!)
    }
    
    override func updateSprite() {
        var frameTime: CGFloat = 1 / 8
        
        if used {
            if useTime == nil {
                useTime = MVCManager.data.universalSpriteIndex
            }
            
            frameTime /= 4
            
            alpha = (0.5 - MVCManager.data.universalSpriteIndex + useTime!) / 0.5
        }
        
        displaySprite(animationSprite(
            spriteTime: MVCManager.data.universalSpriteIndex,
            sprites: [sprites[0], sprites[1], sprites[2], sprites[3], sprites[4], sprites[3], sprites[2], sprites[1]],
            frameTime: frameTime))
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        updateSprite()
    }
    
}
