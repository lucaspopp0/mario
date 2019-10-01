//
//  FireFlower.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class FireFlower: PowerUp {
    
    init(position: CGPoint = CGPoint.zero) {
        super.init(image: #imageLiteral(resourceName: "Fire Flower"), position: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
