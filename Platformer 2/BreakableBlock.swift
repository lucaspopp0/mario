//
//  BreakableBlock.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class BreakableBlock: Block {
    
    var breakSound: Sound?
    
    override func spitItem(toMap map: LevelMap) {
        if isSecret {
            isHidden = false
            isSecret = false
        }
        
        if !canSpit {
            return
        }
        
        if contents.count == 0 {
            if MVCManager.data.player.isBig {
                breakBlock(map)
            } else {
                super.spitItem(toMap: map)
            }
        } else {
            super.spitItem(toMap: map)
        }
    }
    
    override func dropItem(toMap map: LevelMap) {
        if !canSpit {
            return
        }
        
        if contents.count == 0 {
            if MVCManager.data.player.isBig {
                breakBlock(map)
            } else {
                super.dropItem(toMap: map)
            }
        } else {
            super.dropItem(toMap: map)
        }
    }
    
    func breakBlock(_ map: LevelMap) {
        breakSound?.player.play()
        
        map.removeEntity(self)
    }
    
    override func loadSounds(manager: SoundManager) {
        breakSound = manager.loadSound(url: SoundManager.urls["Break Block"]!)
    }
    
}
