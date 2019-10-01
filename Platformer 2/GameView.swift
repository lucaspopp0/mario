//
//  GameView.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

// The view for displaying the game
class GameView: SKView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isMultipleTouchEnabled = true
        
        ignoresSiblingOrder = true
        showsFPS = false
        showsNodeCount = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
