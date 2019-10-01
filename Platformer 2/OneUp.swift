//
//  OneUp.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/18/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class OneUp: PowerUp, Pacing {
    
    var paceSpeed: CGFloat = 80
    var paceDirection: PaceDirection = PaceDirection.right
    var canFallOffEdge: Bool = true
    var isFrozen: Bool = false
    
    init(position: CGPoint = CGPoint.zero) {
        super.init(image: #imageLiteral(resourceName: "1UP"), position: position)
        
        behaviors.append(PaceBehavior(entity: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
