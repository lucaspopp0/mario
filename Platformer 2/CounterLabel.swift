//
//  CounterLabel.swift
//  Platformer 2
//
//  Created by Lucas Popp on 3/13/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class CounterLabel: SKNode {
    
    var size: CGSize = CGSize.zero
    
    var fontName: String? = nil {
        didSet {
            labelNode.fontName = fontName
            layout()
        }
    }
    
    var fontSize: CGFloat = 10 {
        didSet {
            labelNode.fontSize = fontSize
            layout()
        }
    }
    
    var text: String = "" {
        didSet {
            labelNode.text = text
            layout()
        }
    }
    
    var image: UIImage! = UIImage() {
        didSet {
            imageNode.texture = SKTexture(image: image)
            imageNode.size = image.size
            layout()
        }
    }
    
    private let imageNode: SKSpriteNode = SKSpriteNode()
    private let labelNode: SKLabelNode = SKLabelNode()
    
    init(position: CGPoint, image: UIImage, text: String) {
        super.init()
        
        fontSize = 10
        
        addChild(self.imageNode)
        addChild(self.labelNode)
        
        self.text = text
        self.image = image
        
        imageNode.texture = SKTexture(image: image)
        imageNode.size = image.size
        
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        size = CGSize(width: imageNode.size.width + labelNode.frame.size.width, height: max(imageNode.size.height, labelNode.frame.size.height))
        imageNode.position.x = (imageNode.size.width / 2) - (size.width / 2)
        imageNode.position.y = (imageNode.size.height / 2) - (size.height / 2)
        
        labelNode.position.x = (size.width / 2) - (labelNode.frame.size.width / 2)
        labelNode.position.y = -size.height / 2
    }
    
}
