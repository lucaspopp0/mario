//
//  Box.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/24/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class Box: Entity {
    
    init(position: CGPoint, color: String, width: Int, height: Int) {
        super.init(image: #imageLiteral(resourceName: "Green Box Top Left"), position: position)
        
        self.texture = nil
        self.color = UIColor.clear
        
        self.size = CGSize(width: CGFloat(width) * GameScene.TILE_SIZE.width, height: CGFloat(height) * GameScene.TILE_SIZE.height)
        
        var rDescriptor: String = "Center"
        var cDescriptor: String = "Center"
        
        for r in 0 ..< height {
            if r == 0 {
                rDescriptor = "Top"
            } else {
                rDescriptor = "Center"
            }
            
            for c in 0 ..< width {
                if c == 0 {
                    cDescriptor = "Left"
                } else if c == width - 1 {
                    cDescriptor = "Right"
                } else {
                    cDescriptor = "Center"
                }
                
                if let image: UIImage = UIImage(named: "\(color) Box \(rDescriptor) \(cDescriptor)") {
                    let spriteNode: SKSpriteNode = SKSpriteNode(texture: SKTexture(image: image), size: GameScene.TILE_SIZE)
                    spriteNode.position = CGPoint(x: (CGFloat(c) + 0.5) * GameScene.TILE_SIZE.width, y: (CGFloat(height - 1) * GameScene.TILE_SIZE.height) - ((CGFloat(r) + 0.5) * GameScene.TILE_SIZE.height))
                    
                    addChild(spriteNode)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
