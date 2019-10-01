//
//  WorldMap.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/5/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class WorldMap: SKScene {
    
    static let TILE_SIZE: CGSize = CGSize(width: 16, height: 16)
    
    var updating: Bool = true
    
    var map: SKTileMapNode!
    
    var entities: [Entity] = []
    var entitiesAdded: Bool = false
    
    let soundManager: SoundManager = SoundManager()
    var music: Sound?
    var startSound: Sound?
    
    // Used to calculate the time passed each time update is called
    var previousUpdateTime: TimeInterval = 0
    
    let overlay: SKSpriteNode = SKSpriteNode()
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        isUserInteractionEnabled = true
        
        var nodesToRemove: [SKNode] = []
        
        // Locates the level map
        for node: SKNode in children {
            if node is SKTileMapNode && map == nil {
                map = node as! SKTileMapNode
            } else if node is SKSpriteNode {
                nodesToRemove.append(node)
            }
        }
        
        while nodesToRemove.count > 0 {
            nodesToRemove.removeFirst().removeFromParent()
        }
        
        if map.tileSet.name != nil {
            if map.tileSet.name! == "Map Grass" {
                music = soundManager.loadSound(url: SoundManager.urls["Grass Map Music"]!)
            }
        }
        
        startSound = soundManager.loadSound(url: SoundManager.urls["Start Level"]!)
        
        if music != nil {
            // A negative number of loops causes the sound to loop forever
            music!.player.numberOfLoops = -1
        }
        
        overlay.size = self.size
        overlay.anchorPoint = CGPoint.zero
        overlay.position = CGPoint.zero
        overlay.alpha = 0
        overlay.color = UIColor.black
        
        overlay.zPosition = 5
        
        addChild(overlay)
        
        backgroundColor = UIColor.black
    }
    
    func setupScene() {}
    
    func tileCenter(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: (CGFloat(column) + 0.5) * WorldMap.TILE_SIZE.width,
            y: (CGFloat(row) + 0.5) * WorldMap.TILE_SIZE.height)
    }
    
    func tileRect(at point: CGPoint) -> CGRect {
        let center: CGPoint = tileCenter(at: point)
        let offset: CGPoint = CGPoint(x: WorldMap.TILE_SIZE.width / 2, y: WorldMap.TILE_SIZE.height / 2)
        
        return CGRect(origin: center - offset, size: WorldMap.TILE_SIZE)
    }
    
    func tileCenter(at point: CGPoint) -> CGPoint {
        return CGPoint(
            x: (floor(point.x / WorldMap.TILE_SIZE.width) + 0.5) * WorldMap.TILE_SIZE.width,
            y: (floor(point.y / WorldMap.TILE_SIZE.height) + 0.5) * WorldMap.TILE_SIZE.height)
    }
    
    func isWalkable(toThe direction: DPadDirection, of point: CGPoint) -> Bool {
        var newPoint: CGPoint = CGPoint(x: point.x, y: point.y)
        
        switch direction {
        case DPadDirection.down:
            newPoint.y -= WorldMap.TILE_SIZE.height
            break
        case DPadDirection.up:
            newPoint.y += WorldMap.TILE_SIZE.height
            break
        case DPadDirection.left:
            newPoint.x -= WorldMap.TILE_SIZE.width
            break
        case DPadDirection.right:
            newPoint.x += WorldMap.TILE_SIZE.width
            break
        default:
            break
        }
        
        let column: Int = Int(floor(newPoint.x / WorldMap.TILE_SIZE.width))
        let row: Int = Int(floor(newPoint.y / WorldMap.TILE_SIZE.height))
        
        if let groupName: String = map.tileGroup(atColumn: column, row: row)?.name {
            if groupName.contains("Road") || groupName.contains("Level") || groupName.contains("Bridge") {
                return true
            }
        }
        
        return false
    }
    
    func addEntity(_ entity: Entity) {
        if entity.parent != nil {
            entity.removeFromParent()
        }
        
        entities.append(entity)
        
        entity.loadSounds(manager: soundManager)
        
        map.addChild(entity)
    }
    
    func removeEntity(_ entity: Entity) {
        if entity.parent != nil {
            entity.removeFromParent()
        }
        
        let index: Int? = entities.index(of: entity)
        
        if index != nil {
            entities.remove(at: index!)
        }
    }
    
    @objc func aPressed() {
        if let column: Int = MVCManager.data.mapPlayer.currentColumn,
            let row: Int = MVCManager.data.mapPlayer.currentRow {
            
            attemptLevelEntry(atColumn: column, row: row)
        }
    }
    
    func attemptLevelEntry(atColumn column: Int, row: Int) {}
    
    func enterLevel(_ level: GameLevel) {
        MVCManager.data.mapPlayer.isEntering = true
        startSound?.player.play()
        
        MVCManager.data.currentLevel = level
        
        overlay.run(SKAction.fadeIn(withDuration: 2)) {
            MVCManager.controller.loadLevel(named: level.name)
        }
    }
    
    func positionPlayerForLevel(level: GameLevel) {}
    
    // Called every frame
    override func update(_ currentTime: TimeInterval) {
        // Calculates how much time passed since the last frame
        var delta: TimeInterval = currentTime - previousUpdateTime
        
        if delta >= 0.02 {
            delta = 0.02
        }
        
        previousUpdateTime = currentTime
        
        if updating {
            // Forwards the event to the GameController
            MVCManager.controller.updateWorldMap(timeStep: CGFloat(delta))
        }
    }
    
}
