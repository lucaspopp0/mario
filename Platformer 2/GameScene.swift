//
//  GameScene.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    static let TILE_SIZE: CGSize = CGSize(width: 16, height: 16)
    
    var updating: Bool = true
    
    var levelMaps: [LevelMap] = []
    let backgroundNode: SKShapeNode = SKShapeNode()
    
    var currentLevelMap: LevelMap?
    
    // Used to calculate the time passed each time update is called
    var previousUpdateTime: TimeInterval = 0
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        isUserInteractionEnabled = true
        
        var nodesToRemove: [SKNode] = []
        
        // Locates the level map
        for node: SKNode in children {
            if node is SKTileMapNode {
                levelMaps.append(LevelMap(name: node.name, tileMap: node as! SKTileMapNode))
            } else if node is SKSpriteNode {
                nodesToRemove.append(node)
            }
        }
        
        while nodesToRemove.count > 0 {
            nodesToRemove.removeFirst().removeFromParent()
        }
        
        for map: LevelMap in levelMaps {
            map.tileMap.removeFromParent()
            
            Swift.print(map.name ?? "Untitled")
            
            for column: Int in 0 ..< map.tileMap.numberOfColumns {
                for row: Int in 0 ..< map.tileMap.numberOfRows {
                    if tileType(at: CGPoint(x: GameScene.TILE_SIZE.width * (CGFloat(column) + 0.5), y: GameScene.TILE_SIZE.height * (CGFloat(row) + 0.5)), onMap: map.tileMap) == TileType.mysteryBox {
                        Swift.print("\(column), \(row)")
                    }
                }
            }
            
            addEntities(toMap: map)
            addMushroomTrunks(toMap: map)
            addBoxes(toMap: map)
        }
        
        if backgroundNode.parent != nil {
            backgroundNode.removeFromParent()
        }
        
        addChild(backgroundNode)
        backgroundNode.zPosition = -1000
        
        backgroundNode.fillColor = backgroundColor
        backgroundNode.strokeColor = UIColor.clear
        backgroundColor = UIColor.black
    }
    
    func setupScene() {}
    
    func tileCenter(forColumn column: Int, row: Int) -> CGPoint {
        let centerX: CGFloat = (CGFloat(column) + 0.5) * GameScene.TILE_SIZE.width
        let centerY: CGFloat = (CGFloat(row) + 0.5) * GameScene.TILE_SIZE.height
        
        return CGPoint(x: centerX, y: centerY)
    }
    
    func tileCenter(at point: CGPoint) -> CGPoint {
        let centerX: CGFloat = (floor(point.x / GameScene.TILE_SIZE.width) + 0.5) * GameScene.TILE_SIZE.width
        let centerY: CGFloat = (floor(point.y / GameScene.TILE_SIZE.height) + 0.5) * GameScene.TILE_SIZE.height
        
        return CGPoint(x: centerX, y: centerY)
    }
    
    func tileCenter(toThe direction: TileDirection, of point: CGPoint) -> CGPoint {
        var newPoint: CGPoint = CGPoint(x: point.x, y: point.y)
        
        switch direction {
        case TileDirection.bottom:
            newPoint.y -= GameScene.TILE_SIZE.height
            break
        case TileDirection.top:
            newPoint.y += GameScene.TILE_SIZE.height
            break
        case TileDirection.left:
            newPoint.x -= GameScene.TILE_SIZE.width
            break
        case TileDirection.right:
            newPoint.x += GameScene.TILE_SIZE.width
            break
        case TileDirection.bottomRight:
            newPoint.x += GameScene.TILE_SIZE.width
            newPoint.y -= GameScene.TILE_SIZE.height
            break
        case TileDirection.topRight:
            newPoint.x += GameScene.TILE_SIZE.width
            newPoint.y += GameScene.TILE_SIZE.height
            break
        case TileDirection.bottomLeft:
            newPoint.x -= GameScene.TILE_SIZE.width
            newPoint.y -= GameScene.TILE_SIZE.height
            break
        case TileDirection.topLeft:
            newPoint.x -= GameScene.TILE_SIZE.width
            newPoint.y += GameScene.TILE_SIZE.height
            break
        default:
            break
        }
        
        return tileCenter(at: newPoint)
    }
    
    func tileType(at point: CGPoint, onMap map: SKTileMapNode) -> TileType {
        let column: Int = Int(floor(point.x / GameScene.TILE_SIZE.width))
        let row: Int = Int(floor(point.y / GameScene.TILE_SIZE.height))
        
        if 0 <= column && column < map.numberOfColumns && 0 <= row && row < map.numberOfRows {
            return TileType.typeFromGroup(map.tileGroup(atColumn: column, row: row))
        } else {
            return TileType.none
        }
    }
    
    func tileRect(at point: CGPoint) -> CGRect {
        let center: CGPoint = tileCenter(at: point)
        let offset: CGPoint = CGPoint(x: GameScene.TILE_SIZE.width / 2, y: GameScene.TILE_SIZE.height / 2)
        
        return CGRect(origin: center - offset, size: GameScene.TILE_SIZE)
    }
    
    func tileType(toThe direction: TileDirection, of point: CGPoint, onMap map: SKTileMapNode) -> TileType {
        var newPoint: CGPoint = CGPoint(x: point.x, y: point.y)
        
        switch direction {
        case TileDirection.bottom:
            newPoint.y -= GameScene.TILE_SIZE.height
            break
        case TileDirection.top:
            newPoint.y += GameScene.TILE_SIZE.height
            break
        case TileDirection.left:
            newPoint.x -= GameScene.TILE_SIZE.width
            break
        case TileDirection.right:
            newPoint.x += GameScene.TILE_SIZE.width
            break
        case TileDirection.bottomRight:
            newPoint.x += GameScene.TILE_SIZE.width
            newPoint.y -= GameScene.TILE_SIZE.height
            break
        case TileDirection.topRight:
            newPoint.x += GameScene.TILE_SIZE.width
            newPoint.y += GameScene.TILE_SIZE.height
            break
        case TileDirection.bottomLeft:
            newPoint.x -= GameScene.TILE_SIZE.width
            newPoint.y -= GameScene.TILE_SIZE.height
            break
        case TileDirection.topLeft:
            newPoint.x -= GameScene.TILE_SIZE.width
            newPoint.y += GameScene.TILE_SIZE.height
            break
        default:
            break
        }
        
        return tileType(at: newPoint, onMap: map)
    }
    
    func map(named name: String) -> LevelMap? {
        for map: LevelMap in levelMaps {
            if map.name != nil && map.name! == name {
                return map
            }
        }
        
        return nil
    }
    
    func clearSounds() {
        for map: LevelMap in levelMaps {
            map.soundManager.pauseAll()
        }
    }
    
    func displayMap(_ map: LevelMap) {
        currentLevelMap?.music?.player.pause()
        
        currentLevelMap?.tileMap.removeFromParent()
        currentLevelMap?.mushroomLayer.removeFromParent()
        addChild(map.tileMap)
        addChild(map.mushroomLayer)
        
        if currentLevelMap != nil {
            currentLevelMap!.removeEntity(MVCManager.data.player)
        }
        
        MVCManager.data.player.reset()
        
        currentLevelMap = map
        
        backgroundColor = UIColor.black
        
        if map.tileMap.tileSet.name != nil {
            if map.tileMap.tileSet.name! == "Default Grass" {
                backgroundNode.fillColor = GameData.GRASS_BACKGROUND
            } else if map.tileMap.tileSet.name! == "Underground" {
                backgroundNode.fillColor = GameData.UNDERGROUND_BACKGROUND
            }
        }
        
        var bgFrame: CGRect = CGRect(origin: CGPoint.zero, size: map.tileMap.frame.size)
        
        if !map.edgeLimits.topRestricted {
            bgFrame.origin.y -= size.height
            bgFrame.size.height += size.height * 2
        }
        
        if !map.edgeLimits.bottomRestricted {
            bgFrame.origin.y -= size.height
            bgFrame.size.height += size.height * 2
        }
        
        if !map.edgeLimits.leftRestricted {
            bgFrame.origin.x -= size.width
            bgFrame.size.width += size.width * 2
        }
        
        if !map.edgeLimits.rightRestricted {
            bgFrame.origin.x -= size.width
            bgFrame.size.width += size.width * 2
        }
        
        map.tileMap.position = CGPoint.zero
        map.mushroomLayer.position = CGPoint.zero
        backgroundNode.position = CGPoint.zero
        backgroundNode.path = CGPath(rect: bgFrame, transform: nil)
        map.mushroomLayer.path = CGPath(rect: bgFrame, transform: nil)
        
        for trunk: MushroomTrunk in map.trunks {
            trunk.position = trunk.originalPosition
            trunk.position -= CGPoint(x: bgFrame.size.width / 2, y: bgFrame.size.height / 2)
            trunk.height = Int(ceil((bgFrame.size.height / 2) + trunk.position.y))
            trunk.position.y -= trunk.frame.size.height
        }
        
        if !map.entitiesAdded {
            addEntities(toMap: map)
        }
        
        if map.music != nil {
            map.music!.player.play()
        }
    }
    
    func contentsOfBlock(onMap map: LevelMap, atColumn column: Int, row: Int) -> [Item] {
        return []
    }
    
    func addStarCoin(toMap map: LevelMap, atColumn column: CGFloat, row: CGFloat) {
        map.addEntity(StarCoin(position: CGPoint(x: GameScene.TILE_SIZE.width * column, y: GameScene.TILE_SIZE.height * row)))
    }
    
    func addBlock(_ block: Block, toMap map: LevelMap, atColumn column: Int, row: Int) {
        let contents: [Item] = contentsOfBlock(onMap: map, atColumn: column, row: row)
        
        for item: Item in contents {
            block.contents.append(item)
        }
        
        map.addEntity(block)
    }
    
    func addBoxes(toMap map: LevelMap) {
        for row: Int in 0 ..< map.tileMap.numberOfRows {
            var boxStart: Int?
            var boxEnd: Int?
            var color: String?
            
            for column: Int in 0 ..< map.tileMap.numberOfColumns {
                let group: SKTileGroup? = map.tileMap.tileGroup(atColumn: column, row: row)
                
                if group != nil && group!.name != nil {
                    if group!.name!.contains("Box Top") {
                        if group!.name!.contains("Left") {
                            boxStart = column
                            color = group!.name!.substring(to: group!.name!.indexOf(string: " Box"))
                        } else if group!.name!.contains("Right") {
                            boxEnd = column
                        }
                    }
                }
                
                if boxStart != nil && boxEnd != nil {
                    var r: Int = row - 1
                    
                    var allSolid: Bool = false
                    
                    while r >= 0 && !allSolid {
                        allSolid = true
                        
                        for c in boxStart! ... boxEnd! {
                            let type: TileType = tileType(at: tileCenter(forColumn: c, row: r), onMap: map.tileMap)
                            
                            if type == TileType.none {
                                allSolid = false
                                break
                            }
                        }
                        
                        r -= 1
                    }
                    
                    let width: Int = boxEnd! - boxStart! + 1
                    let height: Int = row - r
                    
                    let box: Box = Box(position: CGPoint(x: CGFloat(boxStart!) * GameScene.TILE_SIZE.width, y: (CGFloat(row + 2) * GameScene.TILE_SIZE.height) - (CGFloat(height) * GameScene.TILE_SIZE.height)), color: color!, width: width, height: height)
                    box.zPosition = CGFloat(-300 - row)
                    map.addEntity(box)
                    
                    boxStart = nil
                    boxEnd = nil
                }
            }
        }
    }
    
    func addMushroomTrunks(toMap map: LevelMap) {
        for row: Int in 0 ..< map.tileMap.numberOfRows {
            var mushroomStart: Int?
            var mushroomEnd: Int?
            var isBig: Bool = false
            
            for column: Int in 0 ..< map.tileMap.numberOfColumns {
                let group: SKTileGroup? = map.tileMap.tileGroup(atColumn: column, row: row)
                
                if group != nil && group!.name != nil && group!.name!.contains("Mushroom") {
                    if mushroomStart == nil {
                        if group!.name!.contains("Island") {
                            mushroomStart = column
                            isBig = false
                        } else if group!.name!.contains("Bottom") {
                            mushroomStart = column
                            isBig = true
                        }
                    } else {
                        if group!.name!.contains("Island") && group!.name!.contains("Right") {
                            mushroomEnd = column
                        } else if group!.name!.contains("Right 1") {
                            mushroomEnd = column
                        }
                    }
                }
                
                if mushroomStart != nil && mushroomEnd == nil && column == map.tileMap.numberOfColumns - 1 {
                    mushroomEnd = column
                }
                
                if mushroomStart != nil && mushroomEnd != nil {
                    if (mushroomEnd! - mushroomStart! < 12 && !isBig) || mushroomEnd! - mushroomStart! < 5 && isBig {
                        let trunkTop: CGPoint = CGPoint(
                            x: GameScene.TILE_SIZE.width * (CGFloat(mushroomStart!) + (CGFloat(mushroomEnd! - mushroomStart!) / 2)),
                            y: GameScene.TILE_SIZE.height * CGFloat(row)
                        )
                        
                        map.addTrunk(MushroomTrunk(position: trunkTop, width: 1, height: 3, tileSet: map.tileMap.tileSet))
                    } else {
                        let trunkTop: CGPoint = CGPoint(
                            x: GameScene.TILE_SIZE.width * (CGFloat(mushroomStart!) + (CGFloat(mushroomEnd! - 1 - mushroomStart!) / 2)),
                            y: GameScene.TILE_SIZE.height * CGFloat(row)
                        )
                        
                        map.addTrunk(MushroomTrunk(position: trunkTop, width: 2, height: 3, tileSet: map.tileMap.tileSet))
                    }
                    
                    mushroomStart = nil
                    mushroomEnd = nil
                }
            }
        }
    }
    
    func addRelevantEntities(toMap map: LevelMap, aroundPoint point: CGPoint) {
        let screenSize: CGSize = UIScreen.main.bounds.size
        
        var tileX: CGFloat = point.x - screenSize.width
        
        while tileX <= point.x + screenSize.width {
            var tileY: CGFloat = point.y - screenSize.height
            
            while tileY <= point.y + screenSize.height {
                let column: Int = Int(floor(tileX / GameScene.TILE_SIZE.width))
                let row: Int = Int(floor(tileY / GameScene.TILE_SIZE.height))
                
                let tileGroup: SKTileGroup? = map.tileMap.tileGroup(atColumn: column, row: row)
                
                if tileGroup != nil && tileGroup!.name != nil {
                    if tileGroup!.name! == "Goomba Entry" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let goomba: Goomba = Goomba(position: CGPoint.zero, direction: PaceDirection.left)
                        
                        let tileCenter: CGPoint = self.tileCenter(forColumn: column, row: row)
                        goomba.position = CGPoint(x: tileCenter.x, y: tileCenter.y + (goomba.size.height - GameScene.TILE_SIZE.height) / 2)
                        
                        map.addEntity(goomba)
                    } else if tileGroup!.name! == "Green Koopa Troopa Entry" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let koopaTroopa: KoopaTroopa = GreenKoopaTroopa(position: CGPoint.zero, direction: PaceDirection.left)
                        
                        let tileCenter: CGPoint = self.tileCenter(forColumn: column, row: row)
                        koopaTroopa.position = CGPoint(x: tileCenter.x, y: tileCenter.y + (koopaTroopa.size.height - GameScene.TILE_SIZE.height) / 2)
                        
                        map.addEntity(koopaTroopa)
                    } else if tileGroup!.name! == "Red Koopa Troopa Entry" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let koopaTroopa: KoopaTroopa = RedKoopaTroopa(position: CGPoint.zero, direction: PaceDirection.left)
                        
                        let tileCenter: CGPoint = self.tileCenter(forColumn: column, row: row)
                        koopaTroopa.position = CGPoint(x: tileCenter.x, y: tileCenter.y + (koopaTroopa.size.height - GameScene.TILE_SIZE.height) / 2)
                        
                        map.addEntity(koopaTroopa)
                    } else if tileGroup!.name! == "Dry Bones Entry" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let dryBones: DryBones = DryBones(position: CGPoint.zero, direction: PaceDirection.left)
                        
                        let tileCenter: CGPoint = self.tileCenter(forColumn: column, row: row)
                        dryBones.position = CGPoint(x: tileCenter.x, y: tileCenter.y + (dryBones.size.height - GameScene.TILE_SIZE.height) / 2)
                        
                        map.addEntity(dryBones)
                    }
                }
                
                tileY += GameScene.TILE_SIZE.height
            }
            
            tileX += GameScene.TILE_SIZE.width
        }
        
        let observableRect: CGRect = CGRect(
            x: point.x - (screenSize.width * 0.75),
            y: point.y - (screenSize.height * 0.75),
            width: 1.5 * screenSize.width,
            height: 1.5 * screenSize.height)
        
        for entity: Entity in map.entities {
            if entity is MovingPlatform && observableRect.contains(entity.collisionBoundingBox) && !(entity as! MovingPlatform).isFalling {
                (entity as! MovingPlatform).isMoving = true
            }
        }
    }
    
    func addEntities(toMap map: LevelMap) {
        for column: Int in 0 ..< map.tileMap.numberOfColumns {
            for row: Int in 0 ..< map.tileMap.numberOfRows {
                let tileGroup: SKTileGroup? = map.tileMap.tileGroup(atColumn: column, row: row)
                let tileDefinition: SKTileDefinition? = map.tileMap.tileDefinition(atColumn: column, row: row)
                
                if tileGroup != nil && tileGroup!.name != nil {
                    if tileGroup!.name! == "Breakable Block" && tileDefinition != nil && tileDefinition!.textures.first != nil {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let breakableBlock: BreakableBlock = BreakableBlock(image: UIImage(cgImage: tileDefinition!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up), position: tileCenter(forColumn: column, row: row))
                        
                        addBlock(breakableBlock, toMap: map, atColumn: column, row: row)
                    } else if tileGroup!.name! == "Hidden Breakable Block" && tileDefinition != nil && tileDefinition!.textures.first != nil {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        for group: SKTileGroup in map.tileMap.tileSet.tileGroups {
                            if group.name != nil && group.name! == "Breakable Block" {
                                if let definition: SKTileDefinition = group.rules.first?.tileDefinitions.first {
                                    let breakableBlock: BreakableBlock = BreakableBlock(image: UIImage(cgImage: definition.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up), position: tileCenter(forColumn: column, row: row))
                                    breakableBlock.isSecret = true
                                    breakableBlock.isHidden = true
                                    
                                    addBlock(breakableBlock, toMap: map, atColumn: column, row: row)
                                    break
                                }
                            }
                        }
                    } else if tileGroup!.name! == "Mystery Box" && tileDefinition != nil && tileDefinition!.textures.first != nil {
                        var usedImage: UIImage?
                        
                        for group: SKTileGroup in map.tileMap.tileSet.tileGroups {
                            if group.name != nil && group.name! == "Used Mystery Box" {
                                usedImage = UIImage(cgImage: group.rules.first!.tileDefinitions.first!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up)
                            }
                        }
                        
                        if usedImage != nil {
                            map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                            
                            let mysteryBox: MysteryBox = MysteryBox(image: UIImage(cgImage: tileDefinition!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up), position: tileCenter(forColumn: column, row: row))
                            
                            for texture: SKTexture in tileDefinition!.textures {
                                mysteryBox.animationSprites.append(UIImage(cgImage: texture.cgImage(), scale: 2, orientation: UIImageOrientation.up))
                            }
                            
                            mysteryBox.usedSprite = usedImage!
                            
                            addBlock(mysteryBox, toMap: map, atColumn: column, row: row)
                        }
                    } else if tileGroup!.name! == "Coin" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let coin: Coin = Coin(position: tileCenter(forColumn: column, row: row))
                        
                        map.addEntity(coin)
                    } else if tileGroup!.name! == "Red Coin" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let coin: Coin = Coin(position: tileCenter(forColumn: column, row: row), isRed: true)
                        
                        map.addEntity(coin)
                    } else if tileGroup!.name! == "Star Coin" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        var coinCenter: CGPoint = tileCenter(forColumn: column, row: row)
                        
                        coinCenter.x += GameScene.TILE_SIZE.width / 2
                        coinCenter.y -= GameScene.TILE_SIZE.height / 2
                        
                        let coin: StarCoin = StarCoin(position: coinCenter)
                        
                        map.addEntity(coin)
                    } else if tileGroup!.name! == "Player Entry" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        let tileCenter: CGPoint = self.tileCenter(forColumn: column, row: row)
                        MVCManager.data.player.position = CGPoint(x: tileCenter.x, y: tileCenter.y + (MVCManager.data.player.size.height - GameScene.TILE_SIZE.height) / 2)
                        
                        map.addEntity(MVCManager.data.player)
                    } else if tileGroup!.name! == "Red Door Entry" {
                        map.tileMap.setTileGroup(nil, forColumn: column, row: row)
                        
                        var doorCenter: CGPoint = tileCenter(forColumn: column, row: row)
                        
                        doorCenter.y += GameScene.TILE_SIZE.height / 2
                        
                        let door: CastleDoor = CastleDoor(position: doorCenter)
                        
                        map.addEntity(door)
                    } else if tileGroup!.name! == "Goal Pole Left" {
                        let tileCenter: CGPoint = self.tileCenter(forColumn: column, row: row)
                        let tileRect: CGRect = self.tileRect(at: tileCenter)
                        let goalPole: GoalPole = GoalPole(position: CGPoint.zero)
                        goalPole.position.x = tileCenter.x + (tileRect.size.width / 2)
                        goalPole.position.y = tileCenter.y + (tileRect.size.height / 2) + (goalPole.size.height / 2)
                        
                        map.addEntity(goalPole)
                        map.addEntity(goalPole.bowserFlag)
                        map.addEntity(goalPole.marioFlag)
                    }
                }
            }
        }
        
        map.entitiesAdded = true
    }
    
    func checkPipes() {}
    
    func attemptDoorEntry(_ map: LevelMap, column: Int, row: Int) {
        let entitiesToCheck: [Entity] = MVCManager.data.player.surroundingEntities()
        
        for entity: Entity in entitiesToCheck {
            if entity is CastleDoor {
                if entity.collisionBoundingBox.contains(MVCManager.data.player.desiredPosition) {
                    attemptingToEnterDoor(map, column: column, row: row)
                    break
                }
            }
        }
    }
    
    func attemptingToEnterDoor(_ map: LevelMap, column: Int, row: Int) {}
    
    func useDoorway(entryMap: LevelMap, entryDoor: CastleDoor, exitMap: LevelMap, exitDoor: CastleDoor) {
        MVCManager.data.player.position.x = entryDoor.position.x
        MVCManager.data.player.velocity.x = 0
        MVCManager.data.player.velocity.y = 0
        
        entryDoor.isOpen = true
        entryDoor.openSound?.player.play()
        
        MVCManager.controller.disableControls()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (entryDoor.openSound?.player.duration ?? 0)) {
            MVCManager.data.player.run(SKAction.fadeOut(withDuration: 1), completion: {
                MVCManager.data.scene?.displayMap(exitMap)
                
                exitDoor.isOpen = true
                
                MVCManager.data.player.position.x = exitDoor.position.x
                MVCManager.data.player.position.y = exitDoor.position.y - (exitDoor.size.height / 2) + (MVCManager.data.player.size.height / 2)
                
                exitMap.addEntity(MVCManager.data.player)
                
                MVCManager.data.player.run(SKAction.fadeIn(withDuration: 1), completion: { 
                    exitDoor.isOpen = false
                    exitDoor.closeSound?.player.play()
                    
                    MVCManager.controller.enableControls()
                })
            })
        }
    }
    
    // Forwards touch events to the GameController
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        MVCManager.controller.touchesBegan(touches, with: event, inScene: self)
    }
    
    // Forwards touch events to the GameController
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        MVCManager.controller.touchesMoved(touches, with: event, inScene: self)
    }
    
    // Forwards touch events to the GameController
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        MVCManager.controller.touchesEnded(touches, with: event, inScene: self)
    }
    
    // Called every frame
    override func update(_ currentTime: TimeInterval) {
        // Calculates how much time passed since the last frame
        var delta: TimeInterval = currentTime - previousUpdateTime
        
        if delta >= 0.02 {
            delta = 0.02
        }
        
        previousUpdateTime = currentTime
        
        if updating {
            // Forwards the event to the GameController
            MVCManager.controller.update(timeStep: CGFloat(delta))
        }
    }
    
}
