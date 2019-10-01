//
//  JumpBehavior.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/28/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

protocol Jumping {
    
    var jumpSound: Sound? { get set }
    var wallJumpSound: Sound? { get set }
    
    var jumpSpeed: CGFloat { get set }
    var lastWallJumpDirection: WalkDirection { get set }
    
    // Is the jump button pressed?
    var shouldJump: Bool { get set }
    var shouldGroundPound: Bool { get set }
    
    // Cancels the jump
    var jumpCancelled: Bool { get set }
    
    func jump()
    
    func stopJumping()
    
    func groundPound()
    
}

// Default MovementBehavior for jumping
class JumpBehavior: MovementBehavior {
    
    var alreadyInitiatedJump: Bool = false
    var alreadyInitiatedWallJump: Bool = true
    
    var alreadyInitiatedGroundPound: Bool = false
    
    var wallJumpEnabled: Bool = false
    
    init(entity: MovingEntity, wallJumpEnabled: Bool = false) {
        super.init(entity: entity)
        
        self.wallJumpEnabled = wallJumpEnabled
    }
    
    override func applyBehavior(timeStep: CGFloat) {
        super.applyBehavior(timeStep: timeStep)
        
        if entity is Jumping && MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            var jumpingEntity: Jumping = entity as! Jumping
            
            let onGround: Bool = entity.onGround
            
            if onGround {
                jumpingEntity.jumpCancelled = false
                jumpingEntity.lastWallJumpDirection = WalkDirection.none
                
                if !jumpingEntity.shouldJump {
                    alreadyInitiatedJump = false
                }
                
                jumpingEntity.shouldGroundPound = false
            }
            
            if entity is Walking && jumpingEntity.shouldGroundPound && !onGround {
                var walkingEntity: Walking = entity as! Walking
                
                alreadyInitiatedGroundPound = true
                
                entity.velocity.y = -jumpingEntity.jumpSpeed
                entity.velocity.x = 0
                
                walkingEntity.walkDirection = WalkDirection.none
            } else if jumpingEntity.shouldJump && onGround && !alreadyInitiatedJump {
                entity.velocity.y = jumpingEntity.jumpSpeed
                alreadyInitiatedJump = true
                alreadyInitiatedWallJump = true
                jumpingEntity.jumpSound?.player.play()
            } else {
                if !jumpingEntity.shouldJump && entity.velocity.y > jumpingEntity.jumpSpeed / 2 {
                    entity.velocity.y = jumpingEntity.jumpSpeed / 2
                }
                
                // Handle potential wall jumps
                if entity is Walking && wallJumpEnabled {
                    var walkingEntity: Walking = entity as! Walking
                    
                    var onWall: Bool = false
                    
                    if walkingEntity.walkDirection == WalkDirection.right {
                        let collisionInfo: CollisionInfo = entity.collisionInfo(toThe: TileDirection.right)
                        
                        if collisionInfo.colliding && collisionInfo.type.isSolid {
                            onWall = true
                        } else if entity.isBlock(toThe: TileDirection.right) {
                            onWall = true
                        }
                    } else if walkingEntity.walkDirection == WalkDirection.left {
                        let collisionInfo: CollisionInfo = entity.collisionInfo(toThe: TileDirection.left)
                        
                        if collisionInfo.colliding && collisionInfo.type.isSolid {
                            onWall = true
                        } else if entity.isBlock(toThe: TileDirection.left) {
                            onWall = true
                        }
                    }
                    
                    if onWall && entity.velocity.y < 0 {
                        entity.velocity.y *= 0.9
                    }
                    
                    if onWall && !jumpingEntity.shouldJump {
                        alreadyInitiatedWallJump = false
                    }
                    
                    if jumpingEntity.shouldJump && onWall && !onGround && !alreadyInitiatedWallJump && jumpingEntity.lastWallJumpDirection != walkingEntity.walkDirection {
                        entity.velocity.y = jumpingEntity.jumpSpeed
                        
                        jumpingEntity.wallJumpSound?.player.play()
                        
                        if walkingEntity.walkDirection == WalkDirection.left {
                            entity.velocity.x = jumpingEntity.jumpSpeed
                            jumpingEntity.lastWallJumpDirection = WalkDirection.left
                        } else if walkingEntity.walkDirection == WalkDirection.right {
                            entity.velocity.x = -jumpingEntity.jumpSpeed
                            jumpingEntity.lastWallJumpDirection = WalkDirection.right
                        }
                        
                        walkingEntity.walkDirection = WalkDirection.none
                        alreadyInitiatedWallJump = true
                    } else if !jumpingEntity.shouldJump && entity.velocity.y > jumpingEntity.jumpSpeed / 2 {
                        entity.velocity.y = jumpingEntity.jumpSpeed / 2
                    }
                    
                }
            }
        }
    }
    
}
