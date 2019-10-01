//
//  World2.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/5/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class World2: WorldMap {
    
    override func setupScene() {
        super.setupScene()
        
        if MVCManager.data.mapPlayer.parent != nil {
            MVCManager.data.mapPlayer.removeFromParent()
        }
        
        addEntity(MVCManager.data.mapPlayer)
        
        MVCManager.data.mapPlayer.position = CGPoint(x: 0.5 * WorldMap.TILE_SIZE.width, y: 14.5 * WorldMap.TILE_SIZE.height)
    }
    
}
