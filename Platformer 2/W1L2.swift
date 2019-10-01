//
//  W1L2.swift
//  Platformer 2
//
//  Created by Lucas Popp on 2/24/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class W1L2: GameScene {
    
    var mainMap: LevelMap!
    var undergroundMap: LevelMap!
    
    override func setupScene() {
        super.setupScene()
        
        mainMap = map(named: "Main Map")!
        undergroundMap = map(named: "Underground Map")!
        
        mainMap.edgeLimits.topRestricted = false
        
        displayMap(mainMap)
    }
    
    override func contentsOfBlock(onMap map: LevelMap, atColumn column: Int, row: Int) -> [Item] {
        if map.name != nil {
            if map.name! == "Main Map" {
                if column == 33 && row == 5 {
                    return [SuperMushroom()]
                } else if column == 75 && row == 13 {
                    return [OneUp()]
                } else if column == 93 && row == 9 {
                    return [Coin()]
                } else if column == 96 && row == 9 {
                    if drand48() < 0.5 {
                        return [SuperMushroom()]
                    } else {
                        return [FireFlower()]
                    }
                } else if column == 113 && row == 6 {
                    return [Coin()]
                } else if column == 116 && row == 7 {
                    return [Coin()]
                } else if column == 119 && row == 8 {
                    return [SuperStar()]
                } else if column == 133 && row == 5 {
                    if drand48() < 0.5 {
                        return [SuperMushroom()]
                    } else {
                        return [FireFlower()]
                    }
                }
            }
        }
        
        return []
    }
    
    override func checkPipes() {
        super.checkPipes()
        
        let column: Int = Int(floor(MVCManager.data.player.position.x / GameScene.TILE_SIZE.width))
        let row: Int = Int(floor(MVCManager.data.player.position.y / GameScene.TILE_SIZE.height))
        
        if currentLevelMap != nil && currentLevelMap!.name != nil {
            if currentLevelMap!.name! == "Main Map" {
                if (column == 74 || column == 75) && row == 10 {
                    let collisionInfo: CollisionInfo = MVCManager.data.player.collisionInfo(toThe: TileDirection.bottom)
                    
                    if collisionInfo.type == TileType.pipe && collisionInfo.colliding {
                        if MVCManager.data.controls.dPad.currentDirection == DPadDirection.down {
                            MVCManager.controller.disableControls()
                            MVCManager.data.player.position = CGPoint(x: 75 * 16, y: (10 * 16) + (MVCManager.data.player.size.height / 2))
                            
                            MVCManager.data.player.affectedByGravity = false
                            MVCManager.data.player.collidesWithLevel = false
                            
                            MVCManager.data.player.velocity = CGPoint.zero
                            
                            MVCManager.data.player.zPosition = -5
                            
                            let moveDown: SKAction = SKAction.moveBy(x: 0, y: -MVCManager.data.player.size.height, duration: 1)
                            MVCManager.data.player.run(moveDown)
                            
                            currentLevelMap!.music?.player.stop()
                            MVCManager.data.pipeSound?.player.play()
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                                MVCManager.controller.enableControls()
                                
                                MVCManager.data.player.affectedByGravity = true
                                MVCManager.data.player.collidesWithLevel = true
                                
                                self.displayMap(self.undergroundMap)
                                MVCManager.data.player.position = CGPoint(x: 8 * 16, y: (21 * 16) - (MVCManager.data.player.size.height / 2))
                                self.undergroundMap.addEntity(MVCManager.data.player)
                                
                                MVCManager.data.pipeSound?.player.play()
                                self.undergroundMap.music?.player.play()
                                
                                MVCManager.data.player.zPosition = 1
                            })
                        }
                    }
                }
            } else if currentLevelMap!.name! == "Underground Map" {
                if column == 2 && row == 1 {
                    let collisionInfo: CollisionInfo = MVCManager.data.player.collisionInfo(toThe: TileDirection.left)
                    
                    if collisionInfo.type == TileType.pipe && collisionInfo.colliding {
                        if MVCManager.data.controls.dPad.currentDirection == DPadDirection.left {
                            MVCManager.controller.disableControls()
                            MVCManager.data.player.position = CGPoint(x: 2 * 16, y: (3 * 16) - (MVCManager.data.player.size.height / 2))
                            
                            MVCManager.data.player.affectedByGravity = false
                            MVCManager.data.player.collidesWithLevel = false
                            
                            MVCManager.data.player.velocity = CGPoint.zero
                            
                            MVCManager.data.player.zPosition = -5
                            
                            let moveDown: SKAction = SKAction.moveBy(x: -MVCManager.data.player.size.width, y: 0, duration: 1)
                            MVCManager.data.player.run(moveDown)
                            
                            currentLevelMap!.music?.player.stop()
                            MVCManager.data.pipeSound?.player.play()
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                                MVCManager.controller.enableControls()
                                
                                MVCManager.data.player.affectedByGravity = true
                                MVCManager.data.player.collidesWithLevel = true
                                
                                self.displayMap(self.mainMap)
                                MVCManager.data.player.position = CGPoint(x: 61 * 16, y: (7 * 16) + (MVCManager.data.player.size.height / 2))
                                self.mainMap.addEntity(MVCManager.data.player)
                                
                                MVCManager.data.pipeSound?.player.play()
                                self.mainMap.music?.player.play()
                                
                                MVCManager.data.player.zPosition = 1
                            })
                        }
                    }
                }
            }
        }
    }
    
}
