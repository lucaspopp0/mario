//
//  GameData.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

// Stores all game data
class GameData {
    
    var universalSpriteIndex: CGFloat = 0
    
    static let GRASS_BACKGROUND: UIColor = UIColor(red: 0.094, green: 0.58, blue: 1, alpha: 1)
    static let UNDERGROUND_BACKGROUND: UIColor = UIColor(red: 0.094, green: 0.16, blue: 0.26, alpha: 1)
    
    var worldMap: WorldMap?
    
    var scene: GameScene?
    let player: Player = Player(position: CGPoint.zero)
    let mapPlayer: MapPlayer = MapPlayer(position: CGPoint.zero)
    let controls: GameControls = GameControls()
    
    var currentLevel: GameLevel?
    
    let levels: [[GameLevel]] = [
        [GameLevel(name: "1-1", world: 1),
         GameLevel(name: "1-2", world: 1),
         GameLevel(name: "1-3", world: 1),
         GameLevel(name: "1-4", world: 1),
         GameLevel(name: "1-Tower", world: 1),
         GameLevel(name: "1-5", world: 1),
         GameLevel(name: "1-6", world: 1),
         GameLevel(name: "1-Castle", world: 1)]
    ]
    
    let time1: SKLabelNode = SKLabelNode(fontNamed: "Menlo")
    let time2: SKLabelNode = SKLabelNode(fontNamed: "Menlo")
    
    let lifeCounter: CounterLabel = CounterLabel(position: CGPoint.zero, image: #imageLiteral(resourceName: "Mario Head"), text: "x00")
    let coinCounter: CounterLabel = CounterLabel(position: CGPoint.zero, image: #imageLiteral(resourceName: "Coin 1"), text: "x00")
    
    let pipeSound: Sound? = SoundManager.shared.loadSound(url: SoundManager.urls["Pipe"]!)
    
    var lifeCount: Int = 3 {
        didSet {
            lifeCounter.text = "x\(lifeCount)"
            MVCManager.controller.positionCounters()
        }
    }
    
    var coinCount: Int = 0 {
        didSet {
            coinCounter.text = "x\(coinCount)"
            MVCManager.controller.positionCounters()
        }
    }
    
    init() {
        time1.fontSize = 10
        time1.fontColor = UIColor.red
        time1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        time2.fontSize = 10
        time2.fontColor = UIColor.red
        time2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        coinCounter.text = "x\(coinCount)"
        coinCounter.fontSize = 20
        coinCounter.fontName = "SuperMarioScript3-Regular"
        
        lifeCounter.text = "x\(lifeCount)"
        lifeCounter.fontSize = 20
        lifeCounter.fontName = "SuperMarioScript3-Regular"
    }
    
    func getLevel(world: Int, name: String) -> GameLevel? {
        for level: GameLevel in levels[world - 1] {
            if level.name == name {
                return level
            }
        }
        
        return nil
    }
    
}
