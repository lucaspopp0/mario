//
//  Item.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

// To be subclassed to create items in the game
class Item: MovingEntity {
    
    var usable: Bool = true
    var used: Bool = false
    
}
