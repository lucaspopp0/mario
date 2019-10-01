//
//  Goomba.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/28/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class Goomba: Enemy, Pacing {
    
    var paceDirection: PaceDirection = PaceDirection.left {
        didSet {
            updateSprite()
        }
    }
    
    var canFallOffEdge: Bool = false
    
    var paceSpeed: CGFloat = 40
    var isFrozen: Bool = false
    
    init(position: CGPoint, direction: PaceDirection = PaceDirection.left) {
        super.init(image: #imageLiteral(resourceName: "Goomba 1"), position: position)
        
        paceDirection = direction
        
        minimumSpeedX = -120
        minimumSpeedY = 120
        minimumSpeedY = -450
        maximumSpeedY = 250
        
        behaviors.append(PaceBehavior(entity: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateSprite() {
        displaySprite(animationSprite(spriteTime: MVCManager.data.universalSpriteIndex, sprites: [#imageLiteral(resourceName: "Goomba 1"), #imageLiteral(resourceName: "Goomba 2")], frameTime: 0.25))
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        updateSprite()
    }
    
}
