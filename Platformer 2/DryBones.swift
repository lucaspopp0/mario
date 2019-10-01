//
//  DryBones.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/26/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class DryBones: Enemy, Pacing {
    
    var isInjured: Bool = false
    var injuryTime: CGFloat = 0
    var reconstructTime: CGFloat = 0
    
    var paceDirection: PaceDirection = PaceDirection.left {
        didSet {
            updateSprite()
        }
    }
    
    var canFallOffEdge: Bool = false
    
    var spriteIndex: CGFloat = 0
    var paceSpeed: CGFloat = 35
    var isFrozen: Bool = false
    
    var collapseSound: Sound?
    var rebuildSound: Sound?
    
    init(position: CGPoint, direction: PaceDirection = PaceDirection.left) {
        super.init(image: #imageLiteral(resourceName: "Dry Bones Right 1"), position: position)
        
        paceDirection = direction
        
        minimumSpeedX = -120
        maximumSpeedX = 120
        minimumSpeedY = -450
        maximumSpeedY = 250
        
        behaviors.append(PaceBehavior(entity: self))
        updateSprite()
    }
    
    override func injure() {
        paceSpeed = 0
        isInjured = true
        injuryTime = MVCManager.data.universalSpriteIndex
        reconstructTime = injuryTime + 5.9
        collapseSound?.player.play()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.9, execute: {
            self.isInjured = false
            self.paceSpeed = 35
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.rebuildSound?.player.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadSounds(manager: SoundManager) {
        collapseSound = manager.loadSound(url: SoundManager.urls["Dry Bones Collapse"]!)
        rebuildSound = manager.loadSound(url: SoundManager.urls["Dry Bones Rebuild"]!)
    }
    
    override func displaySprite(_ image: UIImage) {
        let bottom: CGPoint = CGPoint(x: position.x, y: position.y - (size.height / 2))
        
        super.displaySprite(image)
        
        position = CGPoint(x: bottom.x, y: bottom.y + (size.height / 2))
    }
    
    override func updateSprite() {
        if isInjured {
            if paceDirection == PaceDirection.right {
                if MVCManager.data.universalSpriteIndex - injuryTime <= 0.1 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 1 Right"))
                } else if MVCManager.data.universalSpriteIndex - injuryTime <= 0.2 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 2 Right"))
                } else if reconstructTime - MVCManager.data.universalSpriteIndex <= 0.1 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 1 Right"))
                } else if reconstructTime - MVCManager.data.universalSpriteIndex <= 0.2 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 2 Right"))
                } else {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 3 Right"))
                }
            } else {
                if MVCManager.data.universalSpriteIndex - injuryTime <= 0.1 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 1 Left"))
                } else if MVCManager.data.universalSpriteIndex - injuryTime <= 0.2 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 2 Left"))
                } else if reconstructTime - MVCManager.data.universalSpriteIndex <= 0.1 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 1 Left"))
                } else if reconstructTime - MVCManager.data.universalSpriteIndex <= 0.2 {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 2 Left"))
                } else {
                    displaySprite(#imageLiteral(resourceName: "Dry Bones Dead 3 Left"))
                }
            }
        } else {
            if paceDirection == PaceDirection.right {
                displaySprite(animationSprite(spriteTime: MVCManager.data.universalSpriteIndex, sprites: [#imageLiteral(resourceName: "Dry Bones Right 1"), #imageLiteral(resourceName: "Dry Bones Right 2")], frameTime: 0.3))
            } else {
                displaySprite(animationSprite(spriteTime: MVCManager.data.universalSpriteIndex, sprites: [#imageLiteral(resourceName: "Dry Bones Left 1"), #imageLiteral(resourceName: "Dry Bones Left 2")], frameTime: 0.3))
            }
        }
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        updateSprite()
    }
    
}
