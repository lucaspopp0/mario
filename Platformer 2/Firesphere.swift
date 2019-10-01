//
//  Firesphere.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/27/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class Firesphere: Entity {
    
    init() {
        super.init(image: #imageLiteral(resourceName: "Firesphere"), position: CGPoint.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
