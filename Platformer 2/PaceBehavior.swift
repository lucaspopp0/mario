//
//  PaceBehavior.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/29/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

enum PaceDirection {
    
    case left
    case right
    
}

protocol Pacing {
    
    var paceDirection: PaceDirection { get set }
    var paceSpeed: CGFloat { get set }
    var canFallOffEdge: Bool { get set }
    
    var isFrozen: Bool { get set }
    
}

// Default MovementBehavior for pacing
class PaceBehavior: MovementBehavior {
    
    override func applyBehavior(timeStep: CGFloat) {
        super.applyBehavior(timeStep: timeStep)
        
        if entity is Pacing {
            var pacingEntity: Pacing = entity as! Pacing
            
            if !pacingEntity.isFrozen {
                if pacingEntity.paceDirection == PaceDirection.right {
                    if (entity.collidingWithTile(TileDirection.right) && entity.tileToThe(TileDirection.right).isSolid) || entity.collidingWithBlock(toThe: TileDirection.right) {
                        pacingEntity.paceDirection = PaceDirection.left
                    } else if (!pacingEntity.canFallOffEdge && !entity.tileToThe(TileDirection.bottomRight).isSolid && !entity.tileToThe(TileDirection.bottomRight).isOneWay && !entity.isBlock(toThe: TileDirection.bottomRight)) {
                        let pos: CGFloat = (entity!.position.x + (entity!.size.width / 2)) / GameScene.TILE_SIZE.width
                        
                        if pos - floor(pos) < 0.1 {
                            pacingEntity.paceDirection = PaceDirection.left
                        }
                    }
                } else if pacingEntity.paceDirection == PaceDirection.left {
                    if (entity.collidingWithTile(TileDirection.left) && entity.tileToThe(TileDirection.left).isSolid) || entity.collidingWithBlock(toThe: TileDirection.left) {
                        pacingEntity.paceDirection = PaceDirection.right
                    } else if (!pacingEntity.canFallOffEdge && !entity.tileToThe(TileDirection.bottomLeft).isSolid && !entity.tileToThe(TileDirection.bottomLeft).isOneWay && !entity.isBlock(toThe: TileDirection.bottomLeft)) {
                        let pos: CGFloat = (entity!.position.x - (entity!.size.width / 2)) / GameScene.TILE_SIZE.width
                        
                        if pos - floor(pos) < 0.1 {
                            pacingEntity.paceDirection = PaceDirection.right
                        }
                    }
                }
                
                if pacingEntity.paceDirection == PaceDirection.right {
                    entity.velocity.x = pacingEntity.paceSpeed
                } else if pacingEntity.paceDirection == PaceDirection.left {
                    entity.velocity.x = -pacingEntity.paceSpeed
                }
                
                entity.velocity.x *= 0.9
            }
        }
    }
    
}
