//
//  KoopaTroopa.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/30/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class KoopaTroopa: Enemy, Pacing {
    
    var inShell: Bool = false
    
    var paceDirection: PaceDirection = PaceDirection.left {
        didSet {
            updateSprite()
        }
    }
    
    var canFallOffEdge: Bool = true
    
    var spriteIndex: CGFloat = 0
    var paceSpeed: CGFloat = 35
    var isFrozen: Bool = false
    
    var stompSound: Sound?
    
    init(position: CGPoint, direction: PaceDirection = PaceDirection.left) {
        super.init(image: #imageLiteral(resourceName: "Green Koopa Troopa Right 2"), position: position)
        
        paceDirection = direction
        
        minimumSpeedX = -120
        maximumSpeedX = 120
        minimumSpeedY = -450
        maximumSpeedY = 250
        
        behaviors.append(PaceBehavior(entity: self))
        updateSprite()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadSounds(manager: SoundManager) {
        stompSound = manager.loadSound(url: SoundManager.urls["Stomp"]!)
    }
    
    func jumpedOn() {
        if !inShell {
            inShell = true
            paceSpeed = 0
        } else {
            if paceSpeed == 0 {
                moveShell()
            } else {
                paceSpeed = 0
            }
        }
    }
    
    func moveShell() {
        if inShell {
            paceSpeed = 150
        }
    }
    
    override func displaySprite(_ image: UIImage) {
        let koopaBottom: CGPoint = CGPoint(x: position.x, y: position.y - (size.height / 2))
        
        super.displaySprite(image)
        
        position = CGPoint(x: koopaBottom.x, y: koopaBottom.y + (size.height / 2))
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        if inShell && paceSpeed != 0 {
            let entitiesToCheck: [Entity] = surroundingEntities()
            
            for entity: Entity in entitiesToCheck {
                let koopaRect: CGRect = collisionBoundingBox
                let entityRect: CGRect = entity.collisionBoundingBox
                
                if koopaRect.intersects(entityRect) {
                    if entity is Enemy {
                        if entity is KoopaTroopa && (entity as! KoopaTroopa).inShell {
                            if (entity as! KoopaTroopa).paceDirection != paceDirection {
                                if paceDirection == PaceDirection.right && position.x < entity.position.x {
                                    paceDirection = PaceDirection.left
                                    (entity as! KoopaTroopa).paceDirection = PaceDirection.right
                                    (entity as! KoopaTroopa).moveShell()
                                } else if paceDirection == PaceDirection.left && position.x > entity.position.x {
                                    paceDirection = PaceDirection.right
                                    (entity as! KoopaTroopa).paceDirection = PaceDirection.left
                                    (entity as! KoopaTroopa).moveShell()
                                }
                            }
                        } else {
                            (entity as! Enemy).die()
                            stompSound?.player.play()
                        }
                    }
                }
            }
            
            if collidingWithBlock(toThe: TileDirection.right) {
                if let block: Block = block(toThe: TileDirection.right) {
                    if block is BreakableBlock {
                        if let currentMap: LevelMap = MVCManager.data.scene?.currentLevelMap {
                            (block as! BreakableBlock).breakBlock(currentMap)
                        }
                    }
                }
            } else if collidingWithBlock(toThe: TileDirection.left) {
                if let block: Block = block(toThe: TileDirection.left) {
                    if block is BreakableBlock {
                        if let currentMap: LevelMap = MVCManager.data.scene?.currentLevelMap {
                            (block as! BreakableBlock).breakBlock(currentMap)
                        }
                    }
                }
            }
        }
        
        updateSprite()
        spriteIndex += timeStep
    }
    
}

class GreenKoopaTroopa: KoopaTroopa {
    
    override var inShell: Bool {
        didSet {
            if inShell {
                paceSpeed = 0
            } else {
                paceSpeed = 35
            }
            
            updateSprite()
        }
    }
    
    override func updateSprite() {
        if inShell {
            if paceSpeed == 0 {
                spriteIndex = 0
                displaySprite(#imageLiteral(resourceName: "Green Koopa Troopa Shell 0"))
            } else {
                displaySprite(animationSprite(
                    spriteTime: spriteIndex,
                    sprites: [
                        #imageLiteral(resourceName: "Green Koopa Troopa Shell 0"),
                        #imageLiteral(resourceName: "Green Koopa Troopa Shell 1"),
                        #imageLiteral(resourceName: "Green Koopa Troopa Shell 2"),
                        #imageLiteral(resourceName: "Green Koopa Troopa Shell 3")],
                    frameTime: 0.125))
            }
        } else {
            if paceDirection == PaceDirection.left {
                displaySprite(animationSprite(spriteTime: spriteIndex, sprites: [#imageLiteral(resourceName: "Green Koopa Troopa Left 1"), #imageLiteral(resourceName: "Green Koopa Troopa Left 2")], frameTime: 0.3))
            } else {
                displaySprite(animationSprite(spriteTime: spriteIndex, sprites: [#imageLiteral(resourceName: "Green Koopa Troopa Right 1"), #imageLiteral(resourceName: "Green Koopa Troopa Right 2")], frameTime: 0.3))
            }
        }
    }
    
}

class RedKoopaTroopa: KoopaTroopa {
    
    override var inShell: Bool {
        didSet {
            if inShell {
                paceSpeed = 0
                canFallOffEdge = true
            } else {
                paceSpeed = 35
                canFallOffEdge = false
            }
            
            updateSprite()
        }
    }
    
    override init(position: CGPoint, direction: PaceDirection) {
        super.init(position: position, direction: direction)
        canFallOffEdge = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateSprite() {
        if inShell {
            if paceSpeed == 0 {
                spriteIndex = 0
                displaySprite(#imageLiteral(resourceName: "Red Koopa Troopa Shell 0"))
            } else {
                displaySprite(animationSprite(
                    spriteTime: spriteIndex,
                    sprites: [
                        #imageLiteral(resourceName: "Red Koopa Troopa Shell 0"),
                        #imageLiteral(resourceName: "Red Koopa Troopa Shell 1"),
                        #imageLiteral(resourceName: "Red Koopa Troopa Shell 2"),
                        #imageLiteral(resourceName: "Red Koopa Troopa Shell 3")],
                    frameTime: 0.125))
            }
        } else {
            if paceDirection == PaceDirection.left {
                displaySprite(animationSprite(spriteTime: spriteIndex, sprites: [#imageLiteral(resourceName: "Red Koopa Troopa Left 1"), #imageLiteral(resourceName: "Red Koopa Troopa Left 2")], frameTime: 0.3))
            } else {
                displaySprite(animationSprite(spriteTime: spriteIndex, sprites: [#imageLiteral(resourceName: "Red Koopa Troopa Right 1"), #imageLiteral(resourceName: "Red Koopa Troopa Right 2")], frameTime: 0.3))
            }
        }
    }
    
}
