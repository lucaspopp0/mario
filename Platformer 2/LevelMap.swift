//
//  LevelMap.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/2/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit
import AVFoundation

class LevelMap {
    
    struct EdgeLimits {
        
        var topRestricted: Bool
        var rightRestricted: Bool
        var bottomRestricted: Bool
        var leftRestricted: Bool
        
    }
    
    var name: String?
    var tileMap: SKTileMapNode!
    var entitiesAdded: Bool = false
    
    var trunks: [MushroomTrunk] = []
    let mushroomLayer: SKShapeNode = SKShapeNode()
    
    let soundManager: SoundManager = SoundManager()
    
    var music: Sound?
    
    var edgeLimits: EdgeLimits = EdgeLimits(topRestricted: true, rightRestricted: true, bottomRestricted: true, leftRestricted: true)
    
    var entities: [Entity] = []
    var blocks: [Block] = []
    
    init(name: String?, tileMap: SKTileMapNode) {
        self.name = name
        self.tileMap = tileMap
        
        mushroomLayer.zPosition = -500
        mushroomLayer.strokeColor = UIColor.clear
        mushroomLayer.fillColor = UIColor.clear
        
        if tileMap.tileSet.name != nil {
            if tileMap.tileSet.name! == "Default Grass" {
                music = soundManager.loadSound(url: SoundManager.urls["Grass Land Overworld"]!)
            } else if tileMap.tileSet.name! == "Underground" {
                music = soundManager.loadSound(url: SoundManager.urls["Underground Music"]!)
            } else if tileMap.tileSet.name! == "Castle" {
                music = soundManager.loadSound(url: SoundManager.urls["Fortress Music"]!)
            } else {
                music = soundManager.loadSound(url: SoundManager.urls["Grass Land Overworld"]!)
            }
        }
        
        if music != nil {
            // A negative number of loops causes the sound to loop forever
            music!.player.numberOfLoops = -1
        }
    }
    
    func addTrunk(_ trunk: MushroomTrunk) {
        trunks.append(trunk)
        
        trunk.zPosition = -400
        
        mushroomLayer.addChild(trunk)
    }
    
    func removeTrunk(_ trunk: MushroomTrunk) {
        if trunk.parent != nil {
            trunk.removeFromParent()
        }
        
        let index: Int? = trunks.index(of: trunk)
        
        if index != nil {
            trunks.remove(at: index!)
        }
    }
    
    func addEntity(_ entity: Entity) {
        if entity.parent != nil {
            entity.removeFromParent()
        }
        
        entities.append(entity)
        
        if entity is Block {
            blocks.append(entity as! Block)
        }
        
        if entity is FireBar {
            for sphere: Firesphere in (entity as! FireBar).spheres {
                addEntity(sphere)
            }
        }
        
        entity.loadSounds(manager: soundManager)
        
        tileMap.addChild(entity)
        
        entity.map = self
    }
    
    func removeEntity(_ entity: Entity) {
        if entity.parent != nil {
            entity.removeFromParent()
        }
        
        let index: Int? = entities.index(of: entity)
        
        if index != nil {
            entities.remove(at: index!)
        }
        
        if entity is Block {
            let blockIndex: Int? = blocks.index(of: entity as! Block)
            
            if blockIndex != nil {
                blocks.remove(at: blockIndex!)
            }
        }
    }
    
    func tileType(at point: CGPoint) -> TileType {
        let column: Int = Int(floor(point.x / GameScene.TILE_SIZE.width))
        let row: Int = Int(floor(point.y / GameScene.TILE_SIZE.height))
        
        if 0 <= column && column < tileMap.numberOfColumns && 0 <= row && row < tileMap.numberOfRows {
            return TileType.typeFromGroup(tileMap.tileGroup(atColumn: column, row: row))
        } else {
            return TileType.none
        }
    }
    
}
