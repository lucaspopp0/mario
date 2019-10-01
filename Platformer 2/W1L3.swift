//
//  W1L3.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/24/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class W1L3: GameScene {
    
    var mainMap: LevelMap!
    
    override func setupScene() {
        super.setupScene()
        
        mainMap = map(named: "Main Map")!
        
        mainMap.edgeLimits.topRestricted = false
        
        displayMap(mainMap)
    }
    
    override func contentsOfBlock(onMap map: LevelMap, atColumn column: Int, row: Int) -> [Item] {
        if map.name != nil {
            if map.name! == "Main Map" {
                if column == 30 && row == 3 {
                    return [SuperMushroom()]
                } else if column == 32 && row == 5 {
                    return [Coin()]
                } else if column == 33 && row == 2 {
                    return [Coin()]
                } else if column == 38 && row == 5 {
                    return [Coin()]
                } else if column == 40 && row == 3 {
                    return [FireFlower()]
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
