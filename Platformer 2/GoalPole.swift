//
//  GoalPole.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class GoalPole: Entity {
    
    let bowserFlag: Entity = Entity(image: #imageLiteral(resourceName: "Goal Flag"), position: CGPoint.zero)
    let marioFlag: Entity = Entity(image: #imageLiteral(resourceName: "Mario Flag"), position: CGPoint.zero)
    
    var slideSound: Sound?
    
    override var position: CGPoint {
        didSet {
            bowserFlag.position = position + CGPoint(x: (size.width + bowserFlag.size.width) / 2 - 1, y: (size.height / 2) - 5 - (bowserFlag.size.height / 2))
            marioFlag.position = position + CGPoint(x: (size.width + marioFlag.size.width) / 2 - 1, y: -(size.height + marioFlag.size.height) / 2 - 16)
        }
    }
    
    override func removeSounds(fromManager manager: SoundManager) {
        if slideSound != nil {
            manager.removeSound(slideSound!)
        }
    }
    
    override func loadSounds(manager: SoundManager) {
        slideSound = manager.loadSound(url: SoundManager.urls["Goal Pole"]!)
    }
    
    init(position: CGPoint) {
        super.init(image: #imageLiteral(resourceName: "Goal Pole"), position: position)
        zPosition = -20
        
        bowserFlag.zPosition = -25
        marioFlag.zPosition = -24
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
