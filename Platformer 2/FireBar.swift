//
//  FireBar.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/27/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class FireBar: Entity {
    
    var theta: CGFloat = 0
    var spheres: [Firesphere] = []
    var rodLength: Int = 3
    var numberOfRods: Int = 2
    
    var clockwise: Bool = true
    
    init(position: CGPoint, rodLength: Int, numberOfRods: Int, clockwise: Bool = true) {
        super.init(image: #imageLiteral(resourceName: "Default Grass - Stone Block"), position: position)
        
        self.rodLength = rodLength
        self.numberOfRods = numberOfRods
        
        for _ in 0 ..< numberOfRods {
            for _ in 0 ..< rodLength {
                spheres.append(Firesphere())
            }
        }
        
        self.clockwise = clockwise
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        for r in 0 ..< numberOfRods {
            let newTheta: CGFloat = theta + (CGFloat(r) * (CGFloat(2 * M_PI) / CGFloat(numberOfRods)))
            
            for i in 0 ..< rodLength {
                let radius: CGFloat = spheres[i].size.width * CGFloat(i + 1)
                
                spheres[(r * rodLength) + i].position = CGPoint(
                    x: position.x + (radius * cos(newTheta)),
                    y: position.y + (radius * sin(newTheta)))
            }
        }
        
        if clockwise {
            theta -= 0.03
        } else {
            theta += 0.03
        }
    }
    
}
