//
//  Block.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class Block: Entity {
    
    var isSecret: Bool = false
    
    var canSpit: Bool = true
    var canNudge: Bool = true
    
    var contents: [Item] = []
    
    func spitItem(toMap map: LevelMap) {
        if isSecret {
            isHidden = false
            isSecret = false
        }
        
        if !canSpit {
            return
        }
        
        if contents.count > 0 {
            let output: Item = contents.removeFirst()
            
            output.usable = false
            
            output.position = position
            map.addEntity(output)
            
            output.usable = false
            
            if output is Coin {
                output.position.y += (size.height + output.size.height) / 2
                (output as! Coin).launchUp()
            } else {
                output.collidesWithLevel = false
                output.affectedByGravity = false
                
                if output is Pacing {
                    var pacingOutput: Pacing = output as! Pacing
                    pacingOutput.isFrozen = true
                }
                
                output.position.y += 1
                
                let tempZPosition: CGFloat = output.zPosition
                output.zPosition = -5
                
                output.run(SKAction.moveBy(x: 0, y: ((size.height + output.size.height) / 2) - 1, duration: 1), completion: {
                    output.affectedByGravity = true
                    output.collidesWithLevel = true
                    output.zPosition = tempZPosition
                    
                    if output is Pacing {
                        var pacingOutput: Pacing = output as! Pacing
                        pacingOutput.paceDirection = PaceDirection.right
                        pacingOutput.isFrozen = false
                    }
                    
                    output.usable = true
                })
            }
        } else {
            MVCManager.data.player.bumpBlockSound?.player.play()
        }
        
        if canNudge {
            canSpit = false
            nudgeUp()
        }
    }
    
    func dropItem(toMap map: LevelMap) {
        if !canSpit {
            return
        }
        
        if contents.count > 0 {
            let output: Item = contents.removeFirst()
            
            output.position = position + CGPoint(x: 0, y: (size.height - output.size.height) / 2)
            map.addEntity(output)
            
            output.usable = false
            
            if output is Coin {
                (output as! Coin).launchDown()
            } else {
                output.collidesWithLevel = false
                output.affectedByGravity = false
                
                if output is Pacing {
                    var pacingOutput: Pacing = output as! Pacing
                    pacingOutput.isFrozen = true
                }
                
                output.position.y -= 1
                
                let tempZPosition: CGFloat = output.zPosition
                output.zPosition = -5
                
                output.run(SKAction.moveBy(x: 0, y: -((size.height + output.size.height) / 2) + 0.5, duration: 1), completion: {
                    output.affectedByGravity = true
                    output.collidesWithLevel = true
                    output.zPosition = tempZPosition
                    
                    if output is Pacing {
                        var pacingOutput: Pacing = output as! Pacing
                        pacingOutput.paceDirection = PaceDirection.right
                        pacingOutput.isFrozen = false
                    }
                    
                    output.usable = true
                })
            }
        } else {
            MVCManager.data.player.bumpBlockSound?.player.play()
        }
        
        if canNudge {
            canSpit = false
            nudgeDown()
        }
    }
    
    func nudgeUp() {
        let moveAction: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 3, duration: 0.1), SKAction.moveBy(x: 0, y: -3, duration: 0.1)])
        self.run(moveAction) { 
            self.canSpit = true
        }
        
        for entity: Entity in surroundingEntities() {
            if entity is Enemy {
                let enemy: Enemy = entity as! Enemy
                
                if let block: Block = enemy.block(toThe: TileDirection.bottom) {
                    if block.isEqual(self) {
                        enemy.die()
                    }
                }
            }
        }
    }
    
    func nudgeDown() {
        let moveAction: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: -3, duration: 0.1), SKAction.moveBy(x: 0, y: 3, duration: 0.1)])
        self.run(moveAction) {
            self.canSpit = true
        }
    }
    
}
