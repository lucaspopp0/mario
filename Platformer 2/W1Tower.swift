//
//  W1L5.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/25/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class W1Tower: GameScene {
    
    var mainMap: LevelMap!
    var undergroundRoom: LevelMap!
    
    var boss: BoomBoom!
    
    var bossBattleStarted: Bool = false
    
    override func setupScene() {
        super.setupScene()
        
        mainMap = map(named: "Main Map")!
        undergroundRoom = map(named: "Underground Room")!
        
        displayMap(mainMap)
        
        mainMap.addEntity(FireBar(
            position: CGPoint(x: 56.5 * GameScene.TILE_SIZE.width, y: 5.5 * GameScene.TILE_SIZE.height),
            rodLength: 3,
            numberOfRods: 2,
            clockwise: false))
        
        mainMap.addEntity(FireBar(
            position: CGPoint(x: 71.5 * GameScene.TILE_SIZE.width, y: 4.5 * GameScene.TILE_SIZE.height),
            rodLength: 2,
            numberOfRods: 2,
            clockwise: true))
        
        mainMap.addEntity(FireBar(
            position: CGPoint(x: 91.5 * GameScene.TILE_SIZE.width, y: 3.5 * GameScene.TILE_SIZE.height),
            rodLength: 3,
            numberOfRods: 2,
            clockwise: true))
        
        boss = BoomBoom(position: CGPoint(x: 2529, y: 2.5 * GameScene.TILE_SIZE.height))
        
        mainMap.addEntity(boss)
    }
    
    override func contentsOfBlock(onMap map: LevelMap, atColumn column: Int, row: Int) -> [Item] {
        if map.name != nil {
            if map.name! == "Main Map" {
                if row == 4 && column == 98 {
                    return [FireFlower()]
                } else if row == 6 && column == 36 {
                    return [SuperMushroom()]
                }
            }
        }
        
        return []
    }
    
    override func attemptingToEnterDoor(_ map: LevelMap, column: Int, row: Int) {
        if map.name != nil {
            if map.name! == "Main Map" {
                if column == 109 && row == 2 {
                    var entryDoor: CastleDoor?
                    var exitDoor: CastleDoor?
                    
                    for entity: Entity in mainMap.entities {
                        if entity.collisionBoundingBox.contains(MVCManager.data.player.position) && entity is CastleDoor {
                            entryDoor = entity as? CastleDoor
                            break
                        }
                    }
                    
                    for entity: Entity in undergroundRoom.entities {
                        if entity is CastleDoor && entity.collisionBoundingBox.contains(CGPoint(x: GameScene.TILE_SIZE.width * 3.5, y: (GameScene.TILE_SIZE.height * 2) + (MVCManager.data.player.size.height / 2))) {
                            exitDoor = entity as? CastleDoor
                            break
                        }
                    }
                    
                    if entryDoor != nil && exitDoor != nil {
                        useDoorway(
                            entryMap: mainMap,
                            entryDoor: entryDoor!,
                            exitMap: undergroundRoom,
                            exitDoor: exitDoor!)
                    }
                }
            } else if map.name! == "Underground Room" {
                if column == 30 && row == 2 {
                    var entryDoor: CastleDoor?
                    var exitDoor: CastleDoor?
                    
                    for entity: Entity in undergroundRoom.entities {
                        if entity.collisionBoundingBox.contains(MVCManager.data.player.position) && entity is CastleDoor {
                            entryDoor = entity as? CastleDoor
                            break
                        }
                    }
                    
                    for entity: Entity in mainMap.entities {
                        if entity is CastleDoor && entity.collisionBoundingBox.contains(CGPoint(x: GameScene.TILE_SIZE.width * 123.5, y: (GameScene.TILE_SIZE.height * 2) + (MVCManager.data.player.size.height / 2))) {
                            exitDoor = entity as? CastleDoor
                            break
                        }
                    }
                    
                    if entryDoor != nil && exitDoor != nil {
                        useDoorway(
                            entryMap: undergroundRoom,
                            entryDoor: entryDoor!,
                            exitMap: mainMap,
                            exitDoor: exitDoor!)
                    }
                }
            }
        }
    }
    
    override func checkPipes() {}
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if boss.position.x - (boss.size.width / 2) <= GameScene.TILE_SIZE.width * 145 && boss.paceDirection == PaceDirection.left {
            boss.paceDirection = PaceDirection.right
        } else if boss.position.x + (boss.size.width / 2) >= GameScene.TILE_SIZE.width * 158 && boss.paceDirection == PaceDirection.right {
            boss.paceDirection = PaceDirection.left
        }
        
        if let mapName: String = currentLevelMap?.name {
            if mapName == "Main Map" {
                if !bossBattleStarted && MVCManager.data.player.position.x >= 151 * GameScene.TILE_SIZE.width {
                    boss.beginBattle()
                    bossBattleStarted = true
                }
            }
        }
    }
    
}
