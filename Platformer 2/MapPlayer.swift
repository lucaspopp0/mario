//
//  MapPlayer.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/5/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class MapPlayer: MovingEntity {
    
    var direction: DPadDirection = DPadDirection.none {
        didSet {
            updateSprite()
        }
    }
    
    let walkSpeed: CGFloat = 70
    
    var currentColumn: Int?
    var currentRow: Int?
    
    var targetColumn: Int?
    var targetRow: Int?
    
    var isEntering: Bool = false
    
    // Sounds
    let soundManager: SoundManager = SoundManager()
    
    init(position: CGPoint) {
        super.init(image: #imageLiteral(resourceName: "Mario Map - Front"), position: position)
        
        zPosition = 2
        
        affectedByGravity = false
        collidesWithLevel = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateSprite() {
        if isEntering {
            displaySprite(#imageLiteral(resourceName: "Mario Map - Entering"))
        } else {
            if direction == DPadDirection.left {
                displaySprite(#imageLiteral(resourceName: "Mario Map - Left"))
            } else if direction == DPadDirection.right {
                displaySprite(#imageLiteral(resourceName: "Mario Map - Right"))
            } else if direction == DPadDirection.up {
                displaySprite(#imageLiteral(resourceName: "Mario Map - Back"))
            } else {
                displaySprite(#imageLiteral(resourceName: "Mario Map - Front"))
            }
        }
    }
    
    func isCentered() -> Bool {
        if let worldMap: WorldMap = MVCManager.data.worldMap {
            let center: CGPoint = worldMap.tileCenter(at: position)
            
            if abs(position.x - center.x) < 2 && abs(position.y - center.y) < 2 {
                return true
            }
        }
        
        return false
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        if let worldMap: WorldMap = MVCManager.data.worldMap {
            if targetColumn != nil && targetRow != nil {
                let targetPosition: CGPoint = worldMap.tileCenter(column: targetColumn!, row: targetRow!)
                
                if abs(position.x - targetPosition.x) < 2 && abs(position.y - targetPosition.y) < 2 {
                    position = targetPosition
                    targetColumn = nil
                    targetRow = nil
                }
            }
            
            if targetColumn == nil && targetRow == nil {
                direction = MVCManager.data.controls.dPad.currentDirection
                
                if worldMap.isWalkable(toThe: direction, of: position) {
                    if direction == DPadDirection.right {
                        targetColumn = currentColumn! + 1
                        targetRow = currentRow!
                    } else if direction == DPadDirection.left {
                        targetColumn = currentColumn! - 1
                        targetRow = currentRow!
                    } else if direction == DPadDirection.up {
                        targetColumn = currentColumn!
                        targetRow = currentRow! + 1
                    } else if direction == DPadDirection.down {
                        targetColumn = currentColumn!
                        targetRow = currentRow! - 1
                    }
                }
            }
            
            velocity.x = 0
            velocity.y = 0
            
            if !isEntering {
                if direction == DPadDirection.right {
                    velocity.x = walkSpeed
                } else if direction == DPadDirection.left {
                    velocity.x = -walkSpeed
                } else if direction == DPadDirection.up {
                    velocity.y = walkSpeed
                } else if direction == DPadDirection.down {
                    velocity.y = -walkSpeed
                }
            }
            
            if direction != DPadDirection.none && !worldMap.isWalkable(toThe: direction, of: position) {
                if direction == DPadDirection.right {
                    if position.x >= worldMap.tileCenter(at: position).x {
                        velocity.x = 0
                    }
                } else if direction == DPadDirection.left {
                    if position.x <= worldMap.tileCenter(at: position).x {
                        velocity.x = 0
                    }
                } else if direction == DPadDirection.up {
                    if position.y >= worldMap.tileCenter(at: position).y {
                        velocity.y = 0
                    }
                } else if direction == DPadDirection.down {
                    if position.y <= worldMap.tileCenter(at: position).y {
                        velocity.y = 0
                    }
                }
            }
            
            let velocityStep: CGPoint = velocity * timeStep
            
            desiredPosition = position + velocityStep
            
            if velocity.y == 0 {
                desiredPosition.y = worldMap.tileCenter(at: desiredPosition).y
            }
            
            if velocity.x == 0 {
                desiredPosition.x = worldMap.tileCenter(at: desiredPosition).x
            }
            
            position = desiredPosition
            
            currentColumn = Int(floor(position.x / WorldMap.TILE_SIZE.width))
            currentRow = Int(floor(position.y / WorldMap.TILE_SIZE.height))
            
            updateSprite()
        }
    }
    
}
