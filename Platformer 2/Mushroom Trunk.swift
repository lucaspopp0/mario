//
//  Mushroom Trunk.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/16/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class MushroomTrunk: SKShapeNode {
    
    var width: Int! {
        didSet {
            updateTiles()
        }
    }
    
    var height: Int! {
        didSet {
            updateTiles()
        }
    }
    
    var originalPosition: CGPoint!
    var tileSet: SKTileSet!
    
    var tiles: [SKSpriteNode] = []
    
    init(position: CGPoint, width: Int, height: Int, tileSet: SKTileSet) {
        super.init()
        self.tileSet = tileSet
        
        strokeColor = UIColor.clear
        fillColor = UIColor.clear
        
        originalPosition = position
        self.position = position
        self.width = width
        self.height = height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func updateTiles() {
        let size: CGSize = CGSize(width: GameScene.TILE_SIZE.width * CGFloat(width), height: GameScene.TILE_SIZE.height * CGFloat(height))
        
        path = CGPath(rect: CGRect(origin: CGPoint.zero, size: size), transform: nil)
        
        while tiles.count > 0 {
            tiles.removeFirst().removeFromParent()
        }
        
        if width == 1 {
            var topImage: UIImage!
            var regularImage: UIImage!
            
            for group: SKTileGroup in tileSet.tileGroups {
                if group.name != nil && group.name! == "Mushroom Trunk Top" {
                    topImage = UIImage(cgImage: group.rules.first!.tileDefinitions.first!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up)
                } else if group.name != nil && group.name! == "Mushroom Trunk" {
                    regularImage = UIImage(cgImage: group.rules.first!.tileDefinitions.first!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up)
                }
            }
            
            let topTile: SKSpriteNode = SKSpriteNode(texture: SKTexture(image: topImage))
            topTile.position = CGPoint(x: GameScene.TILE_SIZE.width * 0.5, y: size.height - (GameScene.TILE_SIZE.height * 0.5))
            tiles.append(topTile)
            addChild(topTile)
            
            if height >= 1 {
                for row: Int in 1 ... height {
                    let newTile: SKSpriteNode = SKSpriteNode(texture: SKTexture(image: regularImage))
                    newTile.position = CGPoint(x: GameScene.TILE_SIZE.width * 0.5, y: size.height - (GameScene.TILE_SIZE.height * (CGFloat(row) + 0.5)))
                    tiles.append(newTile)
                    addChild(newTile)
                }
            }
        } else if width == 2 {
            var topLeftImage: UIImage!
            var topRightImage: UIImage!
            var regularLeftImage: UIImage!
            var regularRightImage: UIImage!
            
            for group: SKTileGroup in tileSet.tileGroups {
                if group.name != nil && group.name! == "Mushroom Trunk Top Left" {
                    topLeftImage = UIImage(cgImage: group.rules.first!.tileDefinitions.first!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up)
                } else if group.name != nil && group.name! == "Mushroom Trunk Top Right" {
                    topRightImage = UIImage(cgImage: group.rules.first!.tileDefinitions.first!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up)
                } else if group.name != nil && group.name! == "Mushroom Trunk Left" {
                    regularLeftImage = UIImage(cgImage: group.rules.first!.tileDefinitions.first!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up)
                } else if group.name != nil && group.name! == "Mushroom Trunk Right" {
                    regularRightImage = UIImage(cgImage: group.rules.first!.tileDefinitions.first!.textures.first!.cgImage(), scale: 2, orientation: UIImageOrientation.up)
                }
            }
            
            let topLeftTile: SKSpriteNode = SKSpriteNode(texture: SKTexture(image: topLeftImage))
            let topRightTile: SKSpriteNode = SKSpriteNode(texture: SKTexture(image: topRightImage))
            topLeftTile.position = CGPoint(x: GameScene.TILE_SIZE.width * 0.5, y: size.height - (GameScene.TILE_SIZE.height * 0.5))
            topRightTile.position = CGPoint(x: GameScene.TILE_SIZE.width * 1.5, y: size.height - (GameScene.TILE_SIZE.height * 0.5))
            tiles.append(topLeftTile)
            tiles.append(topRightTile)
            addChild(topLeftTile)
            addChild(topRightTile)
            
            if height >= 1 {
                for row: Int in 1 ... height {
                    let leftTile: SKSpriteNode = SKSpriteNode(texture: SKTexture(image: regularLeftImage))
                    let rightTile: SKSpriteNode = SKSpriteNode(texture: SKTexture(image: regularRightImage))
                    
                    leftTile.position = CGPoint(x: GameScene.TILE_SIZE.width * 0.5, y: size.height - (GameScene.TILE_SIZE.height * (CGFloat(row) + 0.5)))
                    rightTile.position = CGPoint(x: GameScene.TILE_SIZE.width * 1.5, y: size.height - (GameScene.TILE_SIZE.height * (CGFloat(row) + 0.5)))
                    
                    tiles.append(leftTile)
                    tiles.append(rightTile)
                    addChild(leftTile)
                    addChild(rightTile)
                }
            }
        }
    }
    
}
