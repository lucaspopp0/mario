//
//  GameController.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit
import AVFoundation

// Performs all actions and modifications. Basically the center of all event handling
@objc class GameController: NSObject {
    
    func tryAgain() {
        let tryAgainScene: SKScene? = SKScene(fileNamed: "TryAgain")
        
        if tryAgainScene != nil {
            MVCManager.view.presentScene(tryAgainScene!)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                if let level: GameLevel = MVCManager.data.currentLevel {
                    self.loadLevel(named: level.name)
                }
            })
        }
    }
    
    func loadMap(named mapName: String) {
        MVCManager.data.scene?.clearSounds()
        MVCManager.data.scene?.updating = false
        MVCManager.data.worldMap?.updating = false
        
        enableControls()
        
        if let mapScene: WorldMap = WorldMap(fileNamed: mapName) {
            MVCManager.data.mapPlayer.isEntering = false
            
            MVCManager.data.scene = nil
            MVCManager.data.worldMap = mapScene
            
            mapScene.updating = false
            
            mapScene.scaleMode = SKSceneScaleMode.aspectFill
            
            mapScene.setupScene()
            
            addControls()
            
            mapScene.updating = true
            
            positionCounters()
            
            MVCManager.view.presentScene(mapScene)
            
            mapScene.music?.player.play()
        }
    }
    
    // Loads a level from a SpriteKit file
    func loadLevel(named levelName: String) {
        MVCManager.data.scene?.clearSounds()
        MVCManager.data.scene?.updating = false
        MVCManager.data.worldMap?.updating = false
        
//        TimeTester.clearTimesFor(name: "isBlock")
//        TimeTester.clearTimesFor(name: "Player.surroundingEntities")
        
        // Reset data from the level
        let levelScene: GameScene? = GameScene(fileNamed: levelName)
        
        enableControls()
        
        if levelScene != nil {
            MVCManager.data.worldMap = nil
            MVCManager.data.scene = levelScene
            
            levelScene!.updating = false
            
            levelScene!.scaleMode = SKSceneScaleMode.aspectFill
            
            levelScene!.setupScene()
            
            addControls()
            levelScene!.updating = true
            
            if MVCManager.data.coinCounter.parent != nil {
                MVCManager.data.coinCounter.removeFromParent()
            }
            
            levelScene!.addChild(MVCManager.data.coinCounter)
            
            if MVCManager.data.lifeCounter.parent != nil {
                MVCManager.data.lifeCounter.removeFromParent()
            }
            
            levelScene!.addChild(MVCManager.data.lifeCounter)
            
            if MVCManager.data.time1.parent != nil {
                MVCManager.data.time1.removeFromParent()
            }
            
            levelScene!.addChild(MVCManager.data.time1)
            
            if MVCManager.data.time2.parent != nil {
                MVCManager.data.time2.removeFromParent()
            }
            
            levelScene!.addChild(MVCManager.data.time2)
            
            MVCManager.data.time1.position = CGPoint(x: levelScene!.frame.size.width / 2, y: MVCManager.data.controls.container.frame.size.height + 40)
            MVCManager.data.time2.position = CGPoint(x: levelScene!.frame.size.width / 2, y: MVCManager.data.controls.container.frame.size.height + 20)
            
            positionCounters()
        }
        
        MVCManager.view.presentScene(levelScene)
        
        if !MVCManager.data.player.checkingFootsteps {
            MVCManager.data.player.checkFootstep()
        }
    }
    
    // Adds the buttons to the scene
    func addControls() {
        var scene: SKScene?
        
        if MVCManager.data.scene != nil {
            scene = MVCManager.data.scene
        } else {
            scene = MVCManager.data.worldMap
        }
        
        if let currentScene: SKScene = scene {
            MVCManager.data.controls.container.position = CGPoint(x: currentScene.size.width / 2, y: MVCManager.data.controls.containerSize.height / 2)
            MVCManager.data.controls.container.zPosition = 180
            
            MVCManager.data.controls.dPad.position = CGPoint(x: -(MVCManager.data.controls.containerSize.width / 2) + (MVCManager.data.controls.containerSize.height / 2), y: 0)
            MVCManager.data.controls.dPad.zPosition = 200
            
            let movement: CGPoint = CGPoint(
                x: ((MVCManager.data.controls.aButton.size.width / 2) + 6) / sqrt(2),
                y: ((MVCManager.data.controls.aButton.size.height / 2) + 6) / sqrt(2)
            )
            
            MVCManager.data.controls.bButton.position = CGPoint(x: (MVCManager.data.controls.containerSize.width / 2) - (MVCManager.data.controls.containerSize.height / 2) - movement.x, y: -movement.y)
            MVCManager.data.controls.bButton.zPosition = 180
            
            MVCManager.data.controls.aButton.position = CGPoint(x: (MVCManager.data.controls.containerSize.width / 2) - (MVCManager.data.controls.containerSize.height / 2) + movement.x, y: movement.y)
            MVCManager.data.controls.aButton.zPosition = 180
            
            if MVCManager.data.controls.container.parent != nil {
                MVCManager.data.controls.container.removeFromParent()
            }
            
            if MVCManager.data.controls.dPad.parent != nil {
                MVCManager.data.controls.dPad.removeFromParent()
            }
            
            if MVCManager.data.controls.aButton.parent != nil {
                MVCManager.data.controls.aButton.removeFromParent()
            }
            
            if MVCManager.data.controls.bButton.parent != nil {
                MVCManager.data.controls.bButton.removeFromParent()
            }
            
            MVCManager.data.controls.dPad.removeAllChangeTargets()
            MVCManager.data.controls.dPad.addChangeTarget(self, with: #selector(GameController.updateDpadDirection))
            
            MVCManager.data.controls.aButton.clearActions()
            MVCManager.data.controls.aButton.addTargetForTouchDown(MVCManager.data.player, with: #selector(Player.aPressed))
            
            
            MVCManager.data.controls.bButton.clearActions()
            MVCManager.data.controls.bButton.addTargetForTouchDown(MVCManager.data.player, with: #selector(Player.jump))
            MVCManager.data.controls.bButton.addTargetForTouchUp(MVCManager.data.player, with: #selector(Player.stopJumping))
            MVCManager.data.controls.bButton.addTargetForTouchExit(MVCManager.data.player, with: #selector(Player.stopJumping))
            
            currentScene.addChild(MVCManager.data.controls.container)
            MVCManager.data.controls.container.addChild(MVCManager.data.controls.dPad)
            MVCManager.data.controls.container.addChild(MVCManager.data.controls.aButton)
            MVCManager.data.controls.container.addChild(MVCManager.data.controls.bButton)
        }
        
        if MVCManager.data.worldMap != nil {
            MVCManager.data.controls.aButton.addTargetForTouchDown(MVCManager.data.worldMap!, with: #selector(WorldMap.aPressed))
        }
    }
    
    func enableControls() {
        MVCManager.data.controls.dPad.isUserInteractionEnabled = true
        MVCManager.data.controls.aButton.isUserInteractionEnabled = true
        MVCManager.data.controls.bButton.isUserInteractionEnabled = true
    }
    
    func disableControls() {
        if MVCManager.data.controls.dPad.currentDirection != DPadDirection.none {
            MVCManager.data.controls.dPad.previousDirection = MVCManager.data.controls.dPad.currentDirection
            MVCManager.data.controls.dPad.currentDirection = DPadDirection.none
        }
        
        if MVCManager.data.controls.aButton.isDown {
            MVCManager.data.controls.aButton.touchUp()
        }
        
        if MVCManager.data.controls.bButton.isDown {
            MVCManager.data.controls.bButton.touchUp()
        }
        
        MVCManager.data.controls.dPad.isUserInteractionEnabled = false
        MVCManager.data.controls.aButton.isUserInteractionEnabled = false
        MVCManager.data.controls.bButton.isUserInteractionEnabled = false
    }
    
    @objc func updateDpadDirection() {
        if MVCManager.data.controls.dPad.currentDirection == DPadDirection.left {
            MVCManager.data.player.walkLeft()
        } else if MVCManager.data.controls.dPad.currentDirection == DPadDirection.right {
            MVCManager.data.player.walkRight()
        } else if MVCManager.data.controls.dPad.currentDirection == DPadDirection.down {
            MVCManager.data.player.groundPound()
        } else {
            MVCManager.data.player.walkNone()
        }
    }
    
    // Positions the count labels
    func positionCounters() {
        if MVCManager.data.scene != nil {
            let scene: GameScene = MVCManager.data.scene!
            
            MVCManager.data.lifeCounter.position = CGPoint(x: 16 + (MVCManager.data.lifeCounter.size.width / 2), y: scene.size.height - 16 - (MVCManager.data.lifeCounter.size.height / 2))
            MVCManager.data.coinCounter.position = CGPoint(x: 16 + (MVCManager.data.coinCounter.size.width / 2), y: MVCManager.data.lifeCounter.position.y - (MVCManager.data.lifeCounter.size.height / 2) - (MVCManager.data.coinCounter.size.height / 2))
        }
    }
    
    // Centers the camera on focus
    func positionWorldMap(focus: CGPoint) {
        if let scene: WorldMap = MVCManager.data.worldMap {
            let map: SKTileMapNode = scene.map
            
            let controlHeight: CGFloat = MVCManager.data.controls.containerSize.height
            let sceneHeight: CGFloat = scene.size.height - controlHeight
            
            let centerOfView: CGPoint = CGPoint(x: scene.size.width / 2, y: controlHeight + (sceneHeight / 2))
            map.position = centerOfView - focus
            
            if focus.x <= scene.size.width / 2 {
                map.position.x = 0
            } else if focus.x >= map.mapSize.width - (scene.size.width / 2) {
                map.position.x = scene.size.width - map.mapSize.width
            }
            
            if focus.y <= sceneHeight / 2 {
                map.position.y = controlHeight
            } else if focus.y >= map.mapSize.height - (sceneHeight / 2) {
                map.position.y = scene.size.height - map.mapSize.height
            }
            
            if map.mapSize.width < scene.size.width {
                map.position.x = (scene.size.width - map.mapSize.width) / 2
            }
            
            if map.mapSize.height < sceneHeight {
                map.position.y = controlHeight + (((scene.size.height - controlHeight) - map.mapSize.height) / 2)
            }
        }
    }
    
    // Centers the camera on focus
    func positionCamera(focus: CGPoint) {
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            let scene: GameScene = MVCManager.data.scene!
            let map: LevelMap = scene.currentLevelMap!
            
            let controlHeight: CGFloat = MVCManager.data.controls.containerSize.height
            let sceneHeight: CGFloat = scene.size.height - controlHeight
            
            let centerOfView: CGPoint = CGPoint(x: scene.size.width / 2, y: controlHeight + (sceneHeight / 2))
            map.tileMap.position = centerOfView - focus
            
            if map.edgeLimits.leftRestricted && focus.x <= scene.size.width / 2 {
                map.tileMap.position.x = 0
            } else if map.edgeLimits.rightRestricted && focus.x >= map.tileMap.mapSize.width - (scene.size.width / 2) {
                map.tileMap.position.x = scene.size.width - map.tileMap.mapSize.width
            }
            
            if map.edgeLimits.bottomRestricted && focus.y <= sceneHeight / 2 {
                map.tileMap.position.y = controlHeight
            } else if map.edgeLimits.topRestricted && focus.y >= map.tileMap.mapSize.height - (sceneHeight / 2) {
                map.tileMap.position.y = scene.size.height - map.tileMap.mapSize.height
            }
            
            if map.edgeLimits.leftRestricted && map.edgeLimits.rightRestricted && map.tileMap.mapSize.width < scene.size.width {
                map.tileMap.position.x = (scene.size.width - map.tileMap.mapSize.width) / 2
            }
            
            if map.edgeLimits.topRestricted && map.edgeLimits.bottomRestricted && map.tileMap.mapSize.height < sceneHeight {
                map.tileMap.position.y = controlHeight + (((scene.size.height - controlHeight) - map.tileMap.mapSize.height) / 2)
            }
            
            scene.backgroundNode.position = map.tileMap.position
            map.mushroomLayer.position = map.tileMap.position + CGPoint(x: map.mushroomLayer.frame.size.width / 2, y: map.mushroomLayer.frame.size.height / 2)
        }
    }
    
    // A handler for touchesBegan
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, inScene scene: GameScene) {}
    
    // A handler for touchesMoved
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, inScene scene: GameScene) {}
    
    // A handler for touchesEnded
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, inScene scene: GameScene) {}
    
    // Called every frame
    func updateWorldMap(timeStep: CGFloat) {
        MVCManager.data.universalSpriteIndex += timeStep
        
        if let worldMap: WorldMap = MVCManager.data.worldMap {
            for entity: Entity in worldMap.entities {
                entity.update(timeStep: timeStep)
            }
            
            positionWorldMap(focus: CGPoint(x: worldMap.map.mapSize.width / 2, y: worldMap.map.mapSize.height / 2))
        }
    }
    
    // Called every frame
    func update(timeStep: CGFloat) {
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            if MVCManager.data.player.currentColumn != MVCManager.data.player.lastColumn || MVCManager.data.player.currentRow != MVCManager.data.player.lastRow {
                MVCManager.data.scene?.addRelevantEntities(toMap: MVCManager.data.scene!.currentLevelMap!, aroundPoint: CGPoint(
                    x: (MVCManager.data.scene!.size.width / 2) - MVCManager.data.scene!.currentLevelMap!.tileMap.position.x,
                    y: (MVCManager.data.scene!.size.height / 2) - MVCManager.data.scene!.currentLevelMap!.tileMap.position.y))
            }
            
            for entity: Entity in MVCManager.data.scene!.currentLevelMap!.entities {
                entity.update(timeStep: timeStep)
            }
        }
        
        MVCManager.data.universalSpriteIndex += timeStep
        
        positionCamera(focus: MVCManager.data.player.position)
    }
    
}
