//
//  World1.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/5/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class World1: WorldMap {
    
    override func setupScene() {
        super.setupScene()
        
        if MVCManager.data.mapPlayer.parent != nil {
            MVCManager.data.mapPlayer.removeFromParent()
        }
        
        addEntity(MVCManager.data.mapPlayer)
        
        MVCManager.data.mapPlayer.position = CGPoint(x: 0.5 * WorldMap.TILE_SIZE.width, y: 14.5 * WorldMap.TILE_SIZE.height)
        
        let bushes: [[Int]] = [
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1],
            [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1],
            [1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1],
            [1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ]
        
        for row in 0 ..< bushes.count {
            for column in 0 ..< bushes[row].count {
                if bushes[row][column] == 1 {
                    addEntity(Bush(
                        sprites: [#imageLiteral(resourceName: "Map Grass - Dancing Bush 1"), #imageLiteral(resourceName: "Map Grass - Dancing Bush 2")],
                        position: CGPoint(x: (CGFloat(column) + 0.5) * WorldMap.TILE_SIZE.width, y: (CGFloat(map.numberOfRows - row - 1) + 0.5) * WorldMap.TILE_SIZE.height)))
                }
            }
        }
        
        MVCManager.data.player.run(SKAction.moveBy(x: WorldMap.TILE_SIZE.width * 2, y: 0, duration: 0.2))
    }
    
    override func attemptLevelEntry(atColumn column: Int, row: Int) {
        if column == 6 && row == 18 {
            if let level: GameLevel = MVCManager.data.getLevel(world: 1, name: "1-1") {
                enterLevel(level)
            }
        } else if column == 13 && row == 18 {
            if let level: GameLevel = MVCManager.data.getLevel(world: 1, name: "1-2") {
                enterLevel(level)
            }
        } else if column == 17 && row == 18 {
            if let level: GameLevel = MVCManager.data.getLevel(world: 1, name: "1-3") {
                enterLevel(level)
            }
        } else if column == 17 && row == 15 {
            if let level: GameLevel = MVCManager.data.getLevel(world: 1, name: "1-4") {
                enterLevel(level)
            }
        } else if column == 10 && row == 10 {
            if let level: GameLevel = MVCManager.data.getLevel(world: 1, name: "1-Tower") {
                enterLevel(level)
            }
        } else if column == 6 && row == 2 {
            if let level: GameLevel = MVCManager.data.getLevel(world: 1, name: "1-5") {
                enterLevel(level)
            }
        } else if column == 13 && row == 2 {
            if let level: GameLevel = MVCManager.data.getLevel(world: 1, name: "1-6") {
                enterLevel(level)
            }
        }
    }
    
    override func positionPlayerForLevel(level: GameLevel) {
        if level.name == "1-1" {
            MVCManager.data.mapPlayer.position = tileCenter(column: 6, row: 18)
        } else if level.name == "1-2" {
            MVCManager.data.mapPlayer.position = tileCenter(column: 13, row: 18)
        } else if level.name == "1-3" {
            MVCManager.data.mapPlayer.position = tileCenter(column: 17, row: 18)
        } else if level.name == "1-4" {
            MVCManager.data.mapPlayer.position = tileCenter(column: 17, row: 15)
        } else if level.name == "1-5" {
            MVCManager.data.mapPlayer.position = tileCenter(column: 6, row: 2)
        } else if level.name == "1-6" {
            MVCManager.data.mapPlayer.position = tileCenter(column: 13, row: 2)
        }
    }
    
}
