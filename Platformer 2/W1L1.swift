//
//  W1L1.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/1/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class W1L1: GameScene {
    
    var mainMap: LevelMap!
    var undergroundMap: LevelMap!
    
    override func setupScene() {
        super.setupScene()
        
        mainMap = map(named: "Main Map")!
        undergroundMap = map(named: "Underground Map")!
        
        mainMap.edgeLimits.topRestricted = false
        
        displayMap(mainMap)
        
        let coinPositions: [CGPoint] = [
            CGPoint(x: 14.5, y: 10),
            CGPoint(x: 15.5, y: 10),
            CGPoint(x: 16.5, y: 9),
            CGPoint(x: 16.5, y: 8),
            CGPoint(x: 15.5, y: 7),
            CGPoint(x: 16.5, y: 6),
            CGPoint(x: 16.5, y: 5),
            CGPoint(x: 15.5, y: 4),
            CGPoint(x: 14.5, y: 4),
            CGPoint(x: 13.5, y: 5),
            CGPoint(x: 14.5, y: 7),
            CGPoint(x: 13.5, y: 9)
        ]
        
        for coinPosition: CGPoint in coinPositions {
            let coin: Coin = Coin(position: CGPoint(x: coinPosition.x * GameScene.TILE_SIZE.width, y: coinPosition.y * GameScene.TILE_SIZE.height), isRed: false)
            
            undergroundMap.addEntity(coin)
        }
    }
    
    override func contentsOfBlock(onMap map: LevelMap, atColumn column: Int, row: Int) -> [Item] {
        if map.name != nil {
            if map.name! == "Main Map" {
                if row == 3 {
                    if column == 93 {
                        return [SuperMushroom()]
                    }
                } else if row == 4 {
                    if column == 11 {
                        return [Coin()]
                    } else if column == 12 {
                        return [Coin()]
                    } else if column == 45 {
                        return [SuperStar()]
                    }
                } else if row == 6 {
                    if column == 26 {
                        return [Coin()]
                    }
                } else if row == 7 {
                    if column == 14 {
                        return [Coin()]
                    } else if column == 15 {
                        return [SuperMushroom()]
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
                if row == 4 && (column == 142 || column == 143) {
                    let collisionInfo: CollisionInfo = MVCManager.data.player.collisionInfo(toThe: TileDirection.bottom)
                    
                    if collisionInfo.type == TileType.pipe && collisionInfo.colliding {
                        if MVCManager.data.controls.dPad.currentDirection == DPadDirection.down {
                            MVCManager.controller.disableControls()
                            MVCManager.data.player.position = CGPoint(x: 143 * 16, y: (4 * 16) + (MVCManager.data.player.size.height / 2))
                            
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
                                MVCManager.data.player.position = CGPoint(x: 9 * 16, y: (10 * 16) - (MVCManager.data.player.size.height / 2))
                                self.undergroundMap.addEntity(MVCManager.data.player)
                                
                                MVCManager.data.pipeSound?.player.play()
                                self.undergroundMap.music?.player.play()
                                
                                MVCManager.data.player.zPosition = 1
                            })
                        }
                    }
                }
            } else if currentLevelMap!.name! == "Underground Map" {
                if row == 9 && (column == 22 || column == 23) {
                    let collisionInfo: CollisionInfo = MVCManager.data.player.collisionInfo(toThe: TileDirection.top)
                    
                    if collisionInfo.type == TileType.pipe && collisionInfo.colliding {
                        if MVCManager.data.controls.dPad.currentDirection == DPadDirection.up {
                            MVCManager.controller.disableControls()
                            MVCManager.data.player.position = CGPoint(x: 23 * 16, y: (10 * 16) - (MVCManager.data.player.size.height / 2))
                            
                            MVCManager.data.player.affectedByGravity = false
                            MVCManager.data.player.collidesWithLevel = false
                            
                            MVCManager.data.player.velocity = CGPoint.zero
                            
                            MVCManager.data.player.zPosition = -5
                            
                            let moveDown: SKAction = SKAction.moveBy(x: 0, y: MVCManager.data.player.size.height, duration: 1)
                            MVCManager.data.player.run(moveDown)
                            
                            currentLevelMap!.music?.player.stop()
                            MVCManager.data.pipeSound?.player.play()
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                                MVCManager.controller.enableControls()
                                
                                MVCManager.data.player.affectedByGravity = true
                                MVCManager.data.player.collidesWithLevel = true
                                
                                self.displayMap(self.mainMap)
                                MVCManager.data.player.position = CGPoint(x: 146 * 16, y: (3 * 16) + (MVCManager.data.player.size.height / 2))
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
