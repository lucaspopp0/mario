//
//  MovingPlatform.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/11/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class MovingPlatform: MovingEntity {
    
    var blocks: [Entity] = []
    
    var isMoving: Bool = false
    var isFalling: Bool = false
    
    init(position: CGPoint, width: Int) {
        super.init(image: #imageLiteral(resourceName: "Default Grass - Solid Block"), position: position)
        
        self.texture = nil
        self.color = UIColor.clear
        
        size.width = GameScene.TILE_SIZE.width * CGFloat(width)
        
        for i in 0 ..< width {
            blocks.append(Entity(
                image: (i == 0 ? #imageLiteral(resourceName: "Default Grass - Ground Island Left") : (i == width - 1 ? #imageLiteral(resourceName: "Default Grass - Ground Island Right") : #imageLiteral(resourceName: "Default Grass - Ground Island Center"))),
                position: CGPoint(x: (GameScene.TILE_SIZE.width * (CGFloat(i) + 0.5)) - (size.width / 2), y: 0)))
            
            addChild(blocks[i])
        }
        
        affectedByGravity = false
        collidesWithLevel = true
        
        g = 225
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(timeStep: CGFloat) {
        if isMoving {
            velocity.x = -30
        } else {
            velocity.x = 0
        }
        
        super.update(timeStep: timeStep)
    }
    
}
