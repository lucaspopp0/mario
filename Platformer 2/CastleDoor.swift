//
//  CastleDoor.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/10/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class CastleDoor: Entity {
    
    var isOpen: Bool = false {
        didSet {
            updateSprite()
        }
    }
    
    var openSound: Sound?
    var closeSound: Sound?
    
    init(position: CGPoint) {
        super.init(image: #imageLiteral(resourceName: "Castle Door Closed"), position: position)
        
        zPosition = -10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadSounds(manager: SoundManager) {
        openSound = manager.loadSound(url: SoundManager.urls["Door Open"]!)
        closeSound = manager.loadSound(url: SoundManager.urls["Door Close"]!)
    }
    
    override func updateSprite() {
        if !isOpen {
            displaySprite(#imageLiteral(resourceName: "Castle Door Closed"))
        } else {
            displaySprite(#imageLiteral(resourceName: "Castle Door Open"))
        }
    }
    
}
