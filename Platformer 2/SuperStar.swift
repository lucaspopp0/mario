//
//  SuperStar.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/21/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class SuperStar: PowerUp, Pacing, Bouncing {
    
    var paceDirection: PaceDirection = PaceDirection.right
    var paceSpeed: CGFloat = 80
    var canFallOffEdge: Bool = true
    
    var isFrozen: Bool = true
    
    var bounceSpeed: CGFloat = 140
    
    var bounceSound: Sound?
    
    init(position: CGPoint = CGPoint.zero) {
        super.init(image: #imageLiteral(resourceName: "Star"), position: position)
        
        behaviors.append(PaceBehavior(entity: self))
        behaviors.append(BounceBehavior(entity: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadSounds(manager: SoundManager) {
        bounceSound = manager.loadSound(url: SoundManager.urls["Starman Bounce"]!)
    }
    
    func bounced() {
        bounceSound?.player.play()
    }
    
}
