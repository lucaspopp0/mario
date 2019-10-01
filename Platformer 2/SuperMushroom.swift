//
//  SuperMushroom.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/29/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class SuperMushroom: PowerUp, Pacing {
    
    var paceSpeed: CGFloat = 80
    var paceDirection: PaceDirection = PaceDirection.right
    var canFallOffEdge: Bool = true
    var isFrozen: Bool = false
    
    init(position: CGPoint = CGPoint.zero) {
        super.init(image: #imageLiteral(resourceName: "Mushroom"), position: position)
        
        behaviors.append(PaceBehavior(entity: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
