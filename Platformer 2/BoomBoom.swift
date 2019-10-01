//
//  BoomBoom.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/12/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

enum BoomBoomStage {
    
    case waiting
    case jumping
    case pacing
    case hurt
    
}

class BoomBoom: Enemy, Pacing, Jumping {
    
    var stage: BoomBoomStage = BoomBoomStage.waiting
    
    // Pacing
    var paceDirection: PaceDirection = PaceDirection.left
    var paceSpeed: CGFloat = 0
    var canFallOffEdge: Bool = true
    var isFrozen: Bool = false
    
    // Jumping
    var jumpSound: Sound? = nil
    var wallJumpSound: Sound? = nil
    var jumpSpeed: CGFloat = 100
    
    var lastWallJumpDirection: WalkDirection = WalkDirection.none
    var shouldJump: Bool = false
    var shouldGroundPound: Bool = false
    var jumpCancelled: Bool = false
    
    var lives: Int = 3
    
    init(position: CGPoint) {
        super.init(image: #imageLiteral(resourceName: "Boom Boom In Shell"), position: position)
        
        behaviors.append(PaceBehavior(entity: self))
        behaviors.append(JumpBehavior(entity: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginBattle() {
        paceSpeed = 35
        paceDirection = PaceDirection.left
        jump()
        
        stage = BoomBoomStage.jumping
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { 
            self.stopJumping()
        }
    }
    
    func jump() {
        shouldJump = true
    }
    
    func stopJumping() {
        shouldJump = false
        jumpCancelled = true
    }
    
    override func injure() {
        stage = BoomBoomStage.hurt
        paceSpeed = 0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5, execute: {
            self.lives -= 1
            
            self.stage = BoomBoomStage.pacing
            
            if self.lives == 2 {
                self.paceSpeed = 55
            } else if self.lives == 1 {
                self.paceSpeed = 75
            } else if self.lives == 0 {
                self.die()
            }
        })
    }
    
    func groundPound() {}
    
    override func updateSprite() {
        if stage == BoomBoomStage.waiting {
            displaySprite(#imageLiteral(resourceName: "Boom Boom In Shell"))
        } else if stage == BoomBoomStage.jumping {
            displaySprite(animationSprite(
                spriteTime: MVCManager.data.universalSpriteIndex,
                sprites: [#imageLiteral(resourceName: "Boom Boom Left 1"), #imageLiteral(resourceName: "Boom Boom Left 2"), #imageLiteral(resourceName: "Boom Boom Left 3"), #imageLiteral(resourceName: "Boom Boom Left 4"),
                          #imageLiteral(resourceName: "Boom Boom Right 1"), #imageLiteral(resourceName: "Boom Boom Right 2"), #imageLiteral(resourceName: "Boom Boom Right 3"), #imageLiteral(resourceName: "Boom Boom Right 4")],
                frameTime: 0.0675))
        } else if stage == BoomBoomStage.pacing {
            displaySprite(animationSprite(
                spriteTime: MVCManager.data.universalSpriteIndex,
                sprites: [#imageLiteral(resourceName: "Boom Boom Left 1"), #imageLiteral(resourceName: "Boom Boom Left 2"), #imageLiteral(resourceName: "Boom Boom Left 3"), #imageLiteral(resourceName: "Boom Boom Left 4"),
                          #imageLiteral(resourceName: "Boom Boom Right 1"), #imageLiteral(resourceName: "Boom Boom Right 2"), #imageLiteral(resourceName: "Boom Boom Right 3"), #imageLiteral(resourceName: "Boom Boom Right 4")],
                frameTime: 0.0675))
        } else if stage == BoomBoomStage.hurt {
            displaySprite(animationSprite(
                spriteTime: MVCManager.data.universalSpriteIndex,
                sprites: [#imageLiteral(resourceName: "Boom Boom Hurt 1"), #imageLiteral(resourceName: "Boom Boom Hurt 2")],
                frameTime: 0.0675))
        }
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        if onGround && stage == BoomBoomStage.jumping && velocity.y < 0 {
            stage = BoomBoomStage.pacing
        }
        
        updateSprite()
    }
    
}
