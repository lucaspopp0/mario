//
//  MovingEntity.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

func rectRounded(_ rect: CGRect) -> CGRect {
    return CGRect(x: round(rect.origin.x), y: round(rect.origin.y), width: round(rect.size.width), height: round(rect.size.height))
}

// An entity that can move
class MovingEntity: Entity {
    
    // Determines whether or not the entity is affected by gravity
    var affectedByGravity: Bool = true
    
    // Determines whether or not the entity collides with tiles in the level
    var collidesWithLevel: Bool = true
    
    // Handle how the entity moves
    var behaviors: [MovementBehavior] = []
    
    // The position the entity will be moved to at the end of update(timeStep:)
    var desiredPosition: CGPoint!
    
    // The speed of the entity
    var velocity: CGPoint = CGPoint.zero
    
    // The maximum allwoed speed of the entity
    var minimumSpeedX: CGFloat = -CGFloat.greatestFiniteMagnitude
    var minimumSpeedY: CGFloat = -CGFloat.greatestFiniteMagnitude
    var maximumSpeedX: CGFloat = CGFloat.greatestFiniteMagnitude
    var maximumSpeedY: CGFloat = CGFloat.greatestFiniteMagnitude
    
    var onGround: Bool {
        get {
            if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
                let scene: GameScene = MVCManager.data.scene!
                
                let bottomCollision: CollisionInfo = collisionInfo(toThe: TileDirection.bottom)
                
                if (bottomCollision.type.isSolid || bottomCollision.type.isOneWay) && bottomCollision.colliding {
                    return true
                }
                
                if tileToThe(TileDirection.bottomLeft).isSolid || tileToThe(TileDirection.bottomRight).isSolid || tileToThe(TileDirection.bottomLeft).isOneWay || tileToThe(TileDirection.bottomRight).isOneWay {
                    let bottomLeftRect: CGRect = scene.tileRect(at: scene.tileCenter(toThe: TileDirection.bottomLeft, of: desiredPosition))
                    let bottomRightRect: CGRect = scene.tileRect(at: scene.tileCenter(toThe: TileDirection.bottomRight, of: desiredPosition))
                    
                    if collisionBoundingBox.intersects(bottomLeftRect) {
                        let intersection: CGRect = collisionBoundingBox.intersection(bottomLeftRect)
                        
                        if intersection.width > intersection.height && intersection.height == 0 {
                            return true
                        }
                    } else if collisionBoundingBox.intersects(bottomRightRect) {
                        let intersection: CGRect = collisionBoundingBox.intersection(bottomRightRect)
                        
                        if intersection.width > intersection.height && intersection.height == 0 {
                            return true
                        }
                    }
                }
            }
            
            if collidingWithBlock(toThe: TileDirection.bottom) {
                return true
            }
            
            for entity: Entity in surroundingEntities() {
                if entity is MovingPlatform {
                    let ownRect: CGRect = collisionBoundingBox
                    let entityRect: CGRect = entity.collisionBoundingBox
                    
                    if CGRect(origin: CGPoint(x: entityRect.origin.x, y: 0), size: entityRect.size).intersects(CGRect(origin: CGPoint(x: ownRect.origin.x, y: 0), size: ownRect.size)) {
                        if round(ownRect.origin.y, places: 1) == round(entityRect.origin.y + entityRect.size.height, places: 1) {
                            return true
                        }
                    }
                }
            }
            
            return false
        }
    }
    
    override var collisionBoundingBox: CGRect {
        get {
            let difference: CGPoint = desiredPosition - position
            
            return frame.offsetBy(dx: difference.x, dy: difference.y)
        }
    }
    
    override init(image: UIImage, position: CGPoint = CGPoint.zero) {
        super.init(image: image, position: position)
        
        desiredPosition = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collisionInfo(toThe direction: TileDirection) -> CollisionInfo {
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            let entityScene: GameScene = MVCManager.data.scene!
            let map: SKTileMapNode = entityScene.currentLevelMap!.tileMap
            
            let entityTileCenter: CGPoint = entityScene.tileCenter(at: desiredPosition)
            let tileCenter: CGPoint = entityScene.tileCenter(toThe: direction, of: desiredPosition)
            let entityRect: CGRect = collisionBoundingBox
            let tileRect: CGRect = entityScene.tileRect(at: tileCenter)
            
            var tileShift: CGPoint = tileCenter - entityTileCenter
            tileShift.x /= GameScene.TILE_SIZE.width
            tileShift.y /= GameScene.TILE_SIZE.height
            
            return CollisionInfo(
                type: entityScene.tileType(toThe: direction, of: entityTileCenter, onMap: map),
                colliding: entityRect.offsetBy(dx: tileShift.x, dy: tileShift.y).intersects(tileRect)
            )
        } else {
            return CollisionInfo(type: TileType.none, colliding: false)
        }
    }
    
    func collidingWithTile(_ direction: TileDirection) -> Bool {
        if MVCManager.data.scene != nil {
            let entityScene: GameScene = MVCManager.data.scene!
            
            let entityTileCenter: CGPoint = entityScene.tileCenter(at: desiredPosition)
            let tileCenter: CGPoint = entityScene.tileCenter(toThe: direction, of: entityTileCenter)
            let entityRect: CGRect = collisionBoundingBox
            let tileRect: CGRect = entityScene.tileRect(at: tileCenter)
            
            var movement: CGPoint = tileCenter - entityTileCenter
            movement.x /= GameScene.TILE_SIZE.width
            movement.y /= GameScene.TILE_SIZE.height
            
            return entityRect.offsetBy(dx: movement.x, dy: movement.y).intersects(tileRect)
        }
        
        return false
    }
    
    func tileToThe(_ direction: TileDirection) -> TileType {
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            let entityScene: GameScene = MVCManager.data.scene!
            let map: SKTileMapNode = entityScene.currentLevelMap!.tileMap
            
            let entityTileCenter: CGPoint = entityScene.tileCenter(at: desiredPosition)
            
            return entityScene.tileType(toThe: direction, of: entityTileCenter, onMap: map)
        } else {
            fatalError("No scene in GameData")
        }
    }
    
    func block(toThe direction: TileDirection) -> Block? {
        var entityPoint: CGPoint = position
        
        let dirString: String = String(describing: direction).lowercased()
        
        if dirString.contains("bottom") {
            entityPoint.y -= size.height / 2 + 1
        } else if dirString.contains("top") {
            entityPoint.y += size.height / 2 + 1
        }
        
        if dirString.contains("left") {
            entityPoint.x -= size.width / 2 + 1
        } else if dirString.contains("right") {
            entityPoint.x += size.width / 2 + 1
        }
        
        for block: Block in surroundingBlocks() {
            if block.collisionBoundingBox.contains(entityPoint) {
                return block
            }
        }
        
        return nil
    }
    
    func isBlock(toThe direction: TileDirection) -> Bool {
//        let testId: Int = TimeTester.beginTest(name: "isBlock")
        
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            let scene: GameScene = MVCManager.data.scene!
            
            let blockCenter: CGPoint = scene.tileCenter(toThe: direction, of: position)
            
            for block: Block in surroundingBlocks() {
                if block.collisionBoundingBox.contains(blockCenter) {
                    return true
                }
            }
        }
        
//        TimeTester.finishedExecuting(testId: testId)
        
        return false
    }
    
    func collidingWithBlock(toThe direction: TileDirection) -> Bool {
        for block: Block in surroundingBlocks() {
            let entityRect: CGRect = rectRounded(collisionBoundingBox)
            let blockRect: CGRect = rectRounded(block.collisionBoundingBox)
            
            if direction == TileDirection.bottom {
                if CGRect(origin: CGPoint(x: entityRect.origin.x, y: 0), size: entityRect.size).intersects(CGRect(origin: CGPoint(x: blockRect.origin.x, y: 0), size: blockRect.size)) {
                    if round(blockRect.origin.y + blockRect.size.height, places: 1) == round(entityRect.origin.y, places: 1) {
                        return true && !(block is BreakableBlock && (block as! BreakableBlock).isHidden)
                    }
                }
            } else if direction == TileDirection.top {
                if CGRect(origin: CGPoint(x: entityRect.origin.x, y: 0), size: entityRect.size).intersects(CGRect(origin: CGPoint(x: blockRect.origin.x, y: 0), size: blockRect.size)) {
                    if round(entityRect.origin.y + entityRect.size.height, places: 1) == round(blockRect.origin.y, places: 1) {
                        return true
                    }
                }
            } else if direction == TileDirection.left {
                if CGRect(origin: CGPoint(x: 0, y: entityRect.origin.y), size: entityRect.size).intersects(CGRect(origin: CGPoint(x: 0, y: blockRect.origin.y), size: blockRect.size)) {
                    if round(blockRect.origin.x + blockRect.size.width, places: 1) == round(entityRect.origin.x, places: 1) {
                        return true
                    }
                }
            } else if direction == TileDirection.right {
                if CGRect(origin: CGPoint(x: 0, y: entityRect.origin.y), size: entityRect.size).intersects(CGRect(origin: CGPoint(x: 0, y: blockRect.origin.y), size: blockRect.size)) {
                    if round(entityRect.origin.x + entityRect.size.width, places: 1) == round(blockRect.origin.x, places: 1) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        if affectedByGravity {
            let gSpeed: CGPoint = CGPoint(x: 0, y: -g)
            let gStep: CGPoint = gSpeed * timeStep
            
            velocity += gStep
        }
        
        // Perform the movement behaviors
        for behavior: MovementBehavior in behaviors {
            behavior.applyBehavior(timeStep: timeStep)
        }
        
        // Restrict the velocity within terminalVelocity
        velocity = CGPoint(x: bind(velocity.x, min: minimumSpeedX, max: maximumSpeedX),
                           y: bind(velocity.y, min: minimumSpeedY, max: maximumSpeedY))
        
        // The amount the position should change proportional to how long has passed since the last frame
        let velocityStep: CGPoint = velocity * timeStep
        
        desiredPosition = position + velocityStep
        
        if collidesWithLevel {
            // The order of directions to check for collisions
            let order: [TileDirection] = [
                TileDirection.bottom,
                TileDirection.top,
                TileDirection.left,
                TileDirection.right,
                TileDirection.bottomRight,
                TileDirection.topRight,
                TileDirection.bottomLeft,
                TileDirection.topLeft
            ]
            
            if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
                // Store the current scene unwrapped in a variable for easy reference
                let entityScene: GameScene = MVCManager.data.scene!
                let map: LevelMap = entityScene.currentLevelMap!
                
                for direction: TileDirection in order {
                    let tileType: TileType = entityScene.tileType(toThe: direction, of: desiredPosition, onMap: map.tileMap)
                    
                    if tileType.isSolid {
                        let entityRect: CGRect = collisionBoundingBox
                        let tileCenter: CGPoint = entityScene.tileCenter(toThe: direction, of: desiredPosition)
                        let tileRect: CGRect = entityScene.tileRect(at: tileCenter)
                        
                        if entityRect.intersects(tileRect) {
                            let intersection: CGRect = entityRect.intersection(tileRect)
                            
                            if !direction.isDiagonal {
                                if direction == TileDirection.bottom {
                                    // Tile is below the entity
                                    desiredPosition.y += intersection.size.height
                                    
                                    // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                    if velocity.y < 0 {
                                        velocity.y = 0
                                    }
                                } else if direction == TileDirection.top {
                                    // Tile is above the entity
                                    desiredPosition.y -= intersection.size.height
                                    velocity.y = 0
                                    
                                    // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                    if velocity.y > 0 {
                                        velocity.y = 0
                                    }
                                } else if direction == TileDirection.left {
                                    // Tile is to the left of the entity
                                    desiredPosition.x += intersection.size.width
                                    
                                    // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                    if velocity.x < 0 {
                                        velocity.x = 0
                                    }
                                } else if direction == TileDirection.right {
                                    // Tile is to the right of the entity
                                    desiredPosition.x -= intersection.size.width
                                    
                                    // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                    if velocity.x > 0 {
                                        velocity.x = 0
                                    }
                                }
                            } else if direction.isDiagonal {
                                if intersection.size.width > intersection.size.height {
                                    // The entity overlaps more horizontally than vertically. Treat the collision as a vertical collision
                                    
                                    var intersectionHeight: CGFloat = intersection.size.height
                                    
                                    if direction == TileDirection.topLeft || direction == TileDirection.topRight {
                                        intersectionHeight *= -1
                                        
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.y > 0 {
                                            velocity.y = 0
                                        }
                                    } else {
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.y < 0 {
                                            velocity.y = 0
                                        }
                                    }
                                    
                                    desiredPosition.y += intersectionHeight
                                } else {
                                    // Treat the collision as a horizontal collision
                                    
                                    var intersectionWidth: CGFloat = intersection.size.width
                                    
                                    if direction == TileDirection.bottomRight || direction == TileDirection.topRight {
                                        intersectionWidth *= -1
                                        
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.x > 0 {
                                            velocity.x = 0
                                        }
                                    } else {
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.x < 0 {
                                            velocity.x = 0
                                        }
                                    }
                                    
                                    desiredPosition.x += intersectionWidth
                                }
                            }
                        }
                    } else if tileType.isSlanted && direction == TileDirection.bottom {
                        let entityRect: CGRect = collisionBoundingBox
                        let tileCenter: CGPoint = entityScene.tileCenter(toThe: direction, of: desiredPosition)
                        let tileRect: CGRect = entityScene.tileRect(at: tileCenter)
                        
                        if entityRect.intersects(tileRect) {
                            let playerX: CGFloat = desiredPosition.x + size.width - (floor(desiredPosition.x / 16) * 16)
                            
                            if 0 <= playerX && playerX < GameScene.TILE_SIZE.width {
                                let tileY: CGFloat = (floor(desiredPosition.y / 16) * 16) + tileType.y(from: playerX)
                                
                                if desiredPosition.y < tileY {
                                    desiredPosition.y = tileY
                                    
                                    if velocity.y < 0 {
                                        velocity.y = 0
                                    }
                                }
                            }
                        }
                    } else if tileType.isOneWay {
                        let entityRect: CGRect = collisionBoundingBox
                        let tileCenter: CGPoint = entityScene.tileCenter(toThe: direction, of: desiredPosition)
                        let tileRect: CGRect = entityScene.tileRect(at: tileCenter)
                        
                        if entityRect.intersects(tileRect) {
                            let intersection: CGRect = entityRect.intersection(tileRect)
                            
                            if !direction.isDiagonal {
                                if direction == TileDirection.bottom {
                                    // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                    if velocity.y < 0 {
                                        velocity.y = 0
                                        desiredPosition.y += intersection.size.height
                                    }
                                }
                            } else if direction.isDiagonal {
                                if intersection.size.width > intersection.size.height {
                                    // The entity overlaps more horizontally than vertically. Treat the collision as a vertical collision
                                    
                                    if direction == TileDirection.bottomLeft || direction == TileDirection.bottomRight {
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.y < 0 {
                                            velocity.y = 0
                                            desiredPosition.y += intersection.size.height
                                        }
                                    }
                                }
                            }
                        }
                    } else if tileType.isHazard {
                        if self is Character {
                            let entityRect: CGRect = collisionBoundingBox
                            let tileCenter: CGPoint = entityScene.tileCenter(toThe: direction, of: desiredPosition)
                            let tileRect: CGRect = entityScene.tileRect(at: tileCenter)
                            
                            if entityRect.intersects(tileRect) {
                                (self as! Character).die()
                            }
                        }
                    }
                }
                
                let entitiesToCheck: [Entity] = surroundingEntities()
                
                for entity: Entity in entitiesToCheck {
                    if collisionBoundingBox.intersects(entity.collisionBoundingBox) {
                        let intersection: CGRect = collisionBoundingBox.intersection(entity.collisionBoundingBox)
                        
                        if entity is Block {
                            if intersection.width > intersection.height {
                                if desiredPosition.y > entity.position.y {
                                    // Block below entity
                                    if !(entity as! Block).isSecret {
                                        desiredPosition.y += intersection.size.height
                                        
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.y < 0 {
                                            velocity.y = 0
                                        }
                                    }
                                } else {
                                    // Block above entity
                                    if !(entity as! Block).isSecret {
                                        desiredPosition.y -= intersection.size.height
                                    }
                                    
                                    // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                    if velocity.y > 0 {
                                        velocity.y = 0
                                    }
                                }
                            } else {
                                if desiredPosition.x > entity.position.x {
                                    // Block left of entity
                                    if !(entity as! Block).isSecret {
                                        desiredPosition.x += intersection.size.width
                                        
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.x < 0 {
                                            velocity.x = 0
                                        }
                                    }
                                } else {
                                    // Block right of entity
                                    if !(entity as! Block).isSecret {
                                        desiredPosition.x -= intersection.size.width
                                        
                                        // If the entity is headed towards the block, stop it. Otherwise, let it keep moving
                                        if velocity.x > 0 {
                                            velocity.x = 0
                                        }
                                    }
                                }
                            }
                        } else if entity is MovingPlatform {
                            if intersection.width > intersection.height {
                                if desiredPosition.y > entity.position.y {
                                    // Platform below entity
                                    desiredPosition.y += intersection.size.height
                                    
                                    // If the entity is headed towards the platform, stop it. Otherwise, let it keep moving
                                    if velocity.y < 0 {
                                        velocity.y = 0
                                    }
                                } else {
                                    // Platform above entity
                                    desiredPosition.y -= intersection.size.height
                                    
                                    // If the entity is headed towards the platform, stop it. Otherwise, let it keep moving
                                    if velocity.y > 0 {
                                        velocity.y = 0
                                    }
                                }
                            } else {
                                if desiredPosition.x > entity.position.x {
                                    // Platform left of entity
                                    desiredPosition.x += intersection.size.width
                                    
                                    // If the entity is headed towards the platform, stop it. Otherwise, let it keep moving
                                    if velocity.x < 0 {
                                        velocity.x = 0
                                    }
                                } else {
                                    // Platform right of entity
                                    desiredPosition.x -= intersection.size.width
                                    
                                    // If the entity is headed towards the platform, stop it. Otherwise, let it keep moving
                                    if velocity.x > 0 {
                                        velocity.x = 0
                                    }
                                }
                            }
                        }
                    }
                    
                    if !(self is MovingPlatform) && entity is MovingPlatform {
                        let ownRect: CGRect = collisionBoundingBox
                        let entityRect: CGRect = entity.collisionBoundingBox
                        
                        if CGRect(origin: CGPoint(x: entityRect.origin.x, y: 0), size: entityRect.size).intersects(CGRect(origin: CGPoint(x: ownRect.origin.x, y: 0), size: ownRect.size)) {
                            if round(ownRect.origin.y, places: 1) == round(entityRect.origin.y + entityRect.size.height, places: 1) {
                                desiredPosition.x += (entity as! MovingEntity).velocity.x * timeStep
                                desiredPosition.y += (entity as! MovingEntity).velocity.y * timeStep
                                break
                            }
                        }
                    }
                }
            }
        }
        
        position = desiredPosition
    }
    
}
