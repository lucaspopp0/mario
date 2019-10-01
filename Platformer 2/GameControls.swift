//
//  GameControls.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/28/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class GameControls {
    
    let containerSize: CGSize = CGSize(width: 375, height: 140)
    
    let container: SKShapeNode = SKShapeNode()
    
    var dPad: DPad!
    
    let aButton: SKButtonNode = SKButtonNode(font: UIFont(name: "Arial-BoldMT", size: 21)!, textColor: UIColor(white: 0, alpha: 0.5), backgroundColor: UIColor(red: 0.97, green: 0.14, blue: 0, alpha: 1))
    let bButton: SKButtonNode = SKButtonNode(font: UIFont(name: "Arial-BoldMT", size: 21)!, textColor: UIColor(white: 0, alpha: 0.5), backgroundColor: UIColor(red: 0.97, green: 0.14, blue: 0, alpha: 1))
    
    init() {
        container.fillColor = UIColor(red: 0.96, green: 0.96, blue: 0.91, alpha: 1)
        container.strokeColor = UIColor(white: 0, alpha: 0.3)
        container.path = CGPath(rect: CGRect(x: -containerSize.width / 2, y: -containerSize.height / 2, width: containerSize.width, height: containerSize.height), transform: nil)
        
        let padSize: CGFloat = containerSize.height - 40
        dPad = DPad(size: CGSize(width: padSize, height: padSize))
        
        let buttonSize: CGFloat = ((padSize * CGFloat(M_SQRT2)) - 15) / CGFloat(1 + M_SQRT2)
        
        aButton.sizeToFit()
        bButton.sizeToFit()
        
        aButton.size = CGSize(width: buttonSize, height: buttonSize)
        bButton.size = CGSize(width: buttonSize, height: buttonSize)
        
        aButton.cornerRadius = aButton.size.width / 2
        bButton.cornerRadius = bButton.size.width / 2
        
        aButton.borderColor = UIColor(white: 0, alpha: 0.5)
        bButton.borderColor = UIColor(white: 0, alpha: 0.5)
        
        aButton.title = "A"
        bButton.title = "B"
    }
    
}
