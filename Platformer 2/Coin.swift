//
//  Coin.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class Coin: Item {
    
    static let LAUNCH_VELOCITY: CGFloat = 150
    
    var sound: Sound?
    
    var launchStart: CGPoint?
    
    var isLaunchingUp: Bool = false
    var isLaunchingDown: Bool = false
    
    var sprites: [UIImage] = []
    
    init(position: CGPoint = CGPoint.zero, isRed: Bool = false) {
        super.init(image: isRed ? #imageLiteral(resourceName: "Red Coin 1") : #imageLiteral(resourceName: "Coin 1"), position: position)
        
        if isRed {
            sprites = [#imageLiteral(resourceName: "Red Coin 1"), #imageLiteral(resourceName: "Red Coin 2"), #imageLiteral(resourceName: "Red Coin 3")]
        } else {
            sprites = [#imageLiteral(resourceName: "Coin 1"), #imageLiteral(resourceName: "Coin 2"), #imageLiteral(resourceName: "Coin 3")]
        }
        
        affectedByGravity = false
        collidesWithLevel = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadSounds(manager: SoundManager) {
        sound = manager.loadSound(url: SoundManager.urls["Coin Grab"]!)
    }
    
    override func updateSprite() {
        var spinStep: CGFloat = 1 / 4
        
        if isLaunchingUp || isLaunchingDown {
            spinStep /= 2
        }
        
        displaySprite(animationSprite(spriteTime: MVCManager.data.universalSpriteIndex, sprites: [sprites[0], sprites[1], sprites[2], sprites[1]], frameTime: spinStep))
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        if isLaunchingUp {
            alpha = sqrt(velocity.y / Coin.LAUNCH_VELOCITY)
            
            if velocity.y <= 0 && !used {
                MVCManager.data.scene?.currentLevelMap?.removeEntity(self)
                MVCManager.data.coinCount += 1
                used = true
                isLaunchingUp = false
            }
        } else if isLaunchingDown {
            alpha = 1 - sqrt((launchStart!.y - position.y) / (GameScene.TILE_SIZE.height * 3))
            
            if launchStart!.y - position.y >= GameScene.TILE_SIZE.height * 3 && !used {
                MVCManager.data.scene?.currentLevelMap?.removeEntity(self)
                MVCManager.data.coinCount += 1
                used = true
                isLaunchingDown = false
            }
        }
        
        updateSprite()
    }
    
    private func launch() {
        collidesWithLevel = false
        affectedByGravity = true
        
        launchStart = self.position
        
        sound?.player.play()
        usable = false
    }
    
    func launchUp() {
        launch()
        
        isLaunchingUp = true
        isLaunchingDown = false
        
        velocity.y = Coin.LAUNCH_VELOCITY
    }
    
    func launchDown() {
        launch()
        
        isLaunchingUp = false
        isLaunchingDown = true
        
        velocity.y = -Coin.LAUNCH_VELOCITY
    }
    
}
