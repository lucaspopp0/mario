//
//  Tiles.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

struct CollisionInfo {
    
    var type: TileType
    var colliding: Bool
    
}

enum TileDirection {
    
    case none
    case bottom
    case top
    case left
    case right
    case bottomRight
    case topRight
    case bottomLeft
    case topLeft
    
    var isVertical: Bool {
        get {
            return self == TileDirection.bottom || self == TileDirection.top
        }
    }
    
    var isHorizontal: Bool {
        get {
            return self == TileDirection.left || self == TileDirection.right
        }
    }
    
    var isDiagonal: Bool {
        get {
            return self == TileDirection.topLeft || self == TileDirection.topRight || self == TileDirection.bottomRight || self == TileDirection.bottomLeft
        }
    }
    
}

enum TileType {
    
    case none
    case empty
    case ground
    case groundRight1x1
    case groundLeft1x1
    case groundRight2x1Short
    case groundRight2x1Tall
    case groundLeft2x1Short
    case groundLeft2x1Tall
    case block
    case breakableBlock
    case mysteryBox
    case usedMysteryBox
    case stoneBlock
    case pipe
    case goalPole
    case mushroomIsland
    case mushroomTop
    case mushroomBottom
    case ledge
    case log
    case cloud
    case boxTop
    case lava
    
    var isSolid: Bool {
        get {
            return self == TileType.ground || self == TileType.block || self == TileType.breakableBlock || self == TileType.mysteryBox || self == TileType.usedMysteryBox || self == TileType.stoneBlock || self == TileType.pipe || self == TileType.goalPole || self == TileType.log
        }
    }
    
    var isOneWay: Bool {
        get {
            return self == TileType.ledge || self == TileType.mushroomIsland || self == TileType.mushroomTop || self == TileType.cloud || self == TileType.boxTop
        }
    }
    
    var isSlanted: Bool {
        get {
            return self == TileType.groundLeft1x1 || self == TileType.groundRight1x1 || self == TileType.groundLeft2x1Short || self == TileType.groundLeft2x1Tall || self == TileType.groundRight2x1Short || self == TileType.groundRight2x1Tall
        }
    }
    
    var isHazard: Bool {
        get {
            return self == TileType.lava
        }
    }
    
    func y(from x: CGFloat) -> CGFloat {
        if isSlanted {
            if self == TileType.groundRight1x1 {
                return x
            } else if self == TileType.groundLeft1x1 {
                return 1 - x
            } else if self == TileType.groundRight2x1Short {
                return x / 2
            } else if self == TileType.groundRight2x1Tall {
                return (x / 2) + 0.5
            } else if self == TileType.groundLeft2x1Short {
                return 0.5 - (x / 2)
            } else if self == TileType.groundLeft2x1Tall {
                return 1 - (x / 2)
            }
        }
        
        return 1
    }
    
    static func typeFromGroup(_ group: SKTileGroup?) -> TileType {
        if group == nil {
            return TileType.none
        } else {
            if group!.name == nil {
                return TileType.empty
            } else if group!.name!.contains("Ground") {
                if group!.name!.contains("1x1") {
                    if group!.name!.contains("Left") {
                        return TileType.groundLeft1x1
                    } else if group!.name!.contains("Right") {
                        return TileType.groundRight1x1
                    }
                } else if group!.name!.contains("2x1") {
                    if group!.name!.contains("Short") {
                        if group!.name!.contains("Left") {
                            return TileType.groundLeft2x1Short
                        } else if group!.name!.contains("Right") {
                            return TileType.groundRight2x1Short
                        }
                    } else if group!.name!.contains("Tall") {
                        if group!.name!.contains("Left") {
                            return TileType.groundLeft2x1Tall
                        } else if group!.name!.contains("Right") {
                            return TileType.groundRight2x1Tall
                        }
                    }
                }
                
                return TileType.ground
            } else if group!.name!.contains("Cloud") {
                return TileType.cloud
            } else if group!.name! == "Solid Block" {
                return TileType.block
            } else if group!.name! == "Breakable Block" {
                return TileType.breakableBlock
            } else if group!.name! == "Mystery Box" {
                return TileType.mysteryBox
            } else if group!.name! == "Used Mystery Box" {
                return TileType.usedMysteryBox
            } else if group!.name! == "Stone Block" {
                return TileType.stoneBlock
            } else if group!.name!.contains("Pipe") {
                return TileType.pipe
            } else if group!.name!.contains("Goal Pole") {
                return TileType.goalPole
            } else if group!.name!.contains("Mushroom") {
                if group!.name!.contains("Top") {
                    return TileType.mushroomTop
                } else if group!.name!.contains("Bottom") {
                    return TileType.mushroomBottom
                } else if group!.name!.contains("Island") {
                    return TileType.mushroomIsland
                }
            } else if group!.name! == "Ledge" {
                return TileType.ledge
            } else if group!.name!.contains("Log") {
                return TileType.log
            } else if group!.name!.contains("Box") && group!.name!.contains("Top") {
                return TileType.boxTop
            } else if group!.name!.contains("Lava") {
                return TileType.lava
            }
            
            return TileType.none
        }
    }
    
}
