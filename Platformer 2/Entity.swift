//
//  Entity.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

// An object (other than a tile) that exists in the game
class Entity: SKSpriteNode {
    
    // Acceleration due to gravity
    var g: CGFloat = 450
    
    var map: LevelMap?
    
    // The CGRect used for detecting collisions with the entity
    var collisionBoundingBox: CGRect {
        get {
            return frame
        }
    }
    
    internal var nearbyCounter: CGFloat = 0
    internal var nearbyEntities: [Entity] = []
    internal var nearbyBlocks: [Block] = []
    
    init(image: UIImage, position: CGPoint = CGPoint.zero) {
        super.init(texture: SKTexture(image: image), color: UIColor.black, size: image.size)
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationSprite(spriteTime: CGFloat, sprites: [UIImage], frameTime: CGFloat) -> UIImage {
        let isolatedTime: CGFloat = spriteTime.truncatingRemainder(dividingBy: frameTime * CGFloat(sprites.count))
        
        let spriteIndex: Int = Int(floor(isolatedTime / frameTime))
        
        return sprites[spriteIndex]
    }
    
    func animationString(spriteTime: CGFloat, strings: [String], frameTime: CGFloat) -> String {
        let isolatedTime: CGFloat = spriteTime.truncatingRemainder(dividingBy: frameTime * CGFloat(strings.count))
        
        let spriteIndex: Int = Int(floor(isolatedTime / frameTime))
        
        return strings[spriteIndex]
    }
    
    func displaySprite(_ image: UIImage) {
        texture = SKTexture(image: image)
        size = image.size
    }
    
    func loadSounds(manager: SoundManager) {}
    
    func removeSounds(fromManager manager: SoundManager) {}
    
    internal func updateNearbyEntities() {
        var newNearbyEntities: [Entity] = []
        var newNearbyBlocks: [Block] = []
        
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            let entityScene: GameScene = MVCManager.data.scene!
            let map: LevelMap = entityScene.currentLevelMap!
            
            for entity: Entity in map.entities {
                if entity != self && CGPoint.distanceBetween(position, and: entity.position) < max(entityScene.size.width, entityScene.size.height) {
                    newNearbyEntities.append(entity)
                    
                    if entity is Block {
                        newNearbyBlocks.append(entity as! Block)
                    }
                }
            }
        }
        
        nearbyEntities = newNearbyEntities
        nearbyBlocks = newNearbyBlocks
    }
    
    func surroundingBlocks() -> [Block] {
        var blocksToCheck: [Block] = []
        
        for block: Block in nearbyBlocks {
            if CGPoint.distanceBetween(position, and: block.position) < max(size.width + block.size.width, size.height + block.size.height) {
                blocksToCheck.append(block)
            }
        }
        
        return blocksToCheck
    }
    
    func surroundingEntities() -> [Entity] {
        var entitiesToCheck: [Entity] = []
        
        for entity: Entity in nearbyEntities {
            if CGPoint.distanceBetween(position, and: entity.position) < max(size.width + entity.size.width, size.height + entity.size.height) {
                entitiesToCheck.append(entity)
            }
        }
        
        return entitiesToCheck
    }
    
    func updateSprite() {}
    
    // To be called each time the SKScene updates
    func update(timeStep: CGFloat) {
        if nearbyCounter == 0 {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                self.updateNearbyEntities()
            }
        }
        
        nearbyCounter += timeStep
        
        if nearbyCounter > 0.5 {
            nearbyCounter = 0
        }
    }
    
}
