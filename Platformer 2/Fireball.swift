//
//  Fireball.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class Fireball: MovingEntity, Pacing, Bouncing {
    
    var bounceSpeed: CGFloat = 200
    
    var paceSpeed: CGFloat = 250
    var paceDirection: PaceDirection = PaceDirection.right
    var canFallOffEdge: Bool = true
    var isFrozen: Bool = false
    
    var spriteIndex: CGFloat = 0
    
    init(position: CGPoint, direction: PaceDirection) {
        super.init(image: #imageLiteral(resourceName: "Fireball 1"), position: position)
        paceDirection = direction
        
        g = 1000
        
        behaviors.append(PaceBehavior(entity: self))
        behaviors.append(BounceBehavior(entity: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bounced() {}
    
    override func updateSprite() {
        super.updateSprite()
        
        let spriteNumber: CGFloat = spriteIndex - floor(spriteIndex)
        
        if spriteNumber < 0.125 {
            displaySprite(#imageLiteral(resourceName: "Fireball 1"))
        } else if spriteNumber < 0.25 {
            displaySprite(#imageLiteral(resourceName: "Fireball 2"))
        } else if spriteNumber < 0.375 {
            displaySprite(#imageLiteral(resourceName: "Fireball 3"))
        } else if spriteNumber < 0.5 {
            displaySprite(#imageLiteral(resourceName: "Fireball 4"))
        } else if spriteNumber < 0.625 {
            displaySprite(#imageLiteral(resourceName: "Fireball 1"))
        } else if spriteNumber < 0.75 {
            displaySprite(#imageLiteral(resourceName: "Fireball 2"))
        } else if spriteNumber < 0.875 {
            displaySprite(#imageLiteral(resourceName: "Fireball 3"))
        } else if spriteNumber < 1 {
            displaySprite(#imageLiteral(resourceName: "Fireball 4"))
        }
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            let map: LevelMap = MVCManager.data.scene!.currentLevelMap!
            
            let entitiesToCheck: [Entity] = surroundingEntities()
            
            for entity: Entity in entitiesToCheck {
                let fireballRect: CGRect = collisionBoundingBox
                let entityRect: CGRect = entity.collisionBoundingBox
                
                if fireballRect.intersects(entityRect) {
                    if entity is Character {
                        (entity as! Character).injure()
                        map.removeEntity(self)
                        break
                    }
                }
            }
            
            if paceDirection == PaceDirection.right {
                if (collidingWithTile(TileDirection.right) && tileToThe(TileDirection.right).isSolid) || collidingWithBlock(toThe: TileDirection.right) {
                    map.removeEntity(self)
                } else if (!canFallOffEdge && !tileToThe(TileDirection.bottomRight).isSolid && !isBlock(toThe: TileDirection.bottomRight)) {
                    let pos: CGFloat = (position.x + (size.width / 2)) / GameScene.TILE_SIZE.width
                    
                    if pos - floor(pos) < 0.1 {
                        map.removeEntity(self)
                    }
                }
            } else if paceDirection == PaceDirection.left {
                if (collidingWithTile(TileDirection.left) && tileToThe(TileDirection.left).isSolid) || collidingWithBlock(toThe: TileDirection.left) {
                    map.removeEntity(self)
                } else if (!canFallOffEdge && !tileToThe(TileDirection.bottomLeft).isSolid && !isBlock(toThe: TileDirection.bottomLeft)) {
                    let pos: CGFloat = (position.x - (size.width / 2)) / GameScene.TILE_SIZE.width
                    
                    if pos - floor(pos) < 0.1 {
                        map.removeEntity(self)
                    }
                }
            }
        }
        
        updateSprite()
        spriteIndex += timeStep
    }
    
}
