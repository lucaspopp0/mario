//
//  W1L4.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/25/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class W1L4: GameScene {
    
    var mainMap: LevelMap!
    
    override func setupScene() {
        super.setupScene()
        
        mainMap = map(named: "Main Map")!
        
        mainMap.edgeLimits.topRestricted = false
        
        displayMap(mainMap)
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 24.5, y: GameScene.TILE_SIZE.height * 6.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 36.5, y: GameScene.TILE_SIZE.height * 4.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 38.5, y: GameScene.TILE_SIZE.height * 7.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 40.5, y: GameScene.TILE_SIZE.height * 1.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 48.5, y: GameScene.TILE_SIZE.height * 5.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 69.5, y: GameScene.TILE_SIZE.height * 2.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 76.5, y: GameScene.TILE_SIZE.height * 6.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 87.5, y: GameScene.TILE_SIZE.height * 4.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 89.5, y: GameScene.TILE_SIZE.height * 5.5),
            width: 3))
        
        mainMap.addEntity(MovingPlatform(
            position: CGPoint(x: GameScene.TILE_SIZE.width * 98.5, y: GameScene.TILE_SIZE.height * 7.5),
            width: 3))
    }
    
    override func contentsOfBlock(onMap map: LevelMap, atColumn column: Int, row: Int) -> [Item] {
        if map.name != nil {
            if map.name! == "Main Map" {
                if column == 103 && row == 5 {
                    return [OneUp()]
                }
            }
        }
        
        return []
    }
    
    override func checkPipes() {
        super.checkPipes()
        
        let column: Int = Int(floor(MVCManager.data.player.position.x / GameScene.TILE_SIZE.width))
        let row: Int = Int(floor(MVCManager.data.player.position.y / GameScene.TILE_SIZE.height))
        
        if currentLevelMap != nil && currentLevelMap!.name != nil {
            if currentLevelMap!.name! == "Main Map" {
                
            }
        }
    }
    
}
