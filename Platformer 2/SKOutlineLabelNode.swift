//
//  SKOutlineLabelNode.swift
//  Platformer 2
//
//  Created by Lucas Popp on 1/7/17.
//  Copyright © 2017 Lucas Popp. All rights reserved.
//

import SpriteKit

class SKOutlineLabelNode: SKLabelNode {
    
    var textNodes: [SKShapeNode] = []
    var borderNodes: [SKShapeNode] = []
    
    var borderWidth: CGFloat = 1 {
        didSet {
            drawBorder()
            
            for borderNode: SKShapeNode in borderNodes {
                borderNode.lineWidth = borderWidth * 2
            }
        }
    }
    
    var borderColor: UIColor = UIColor.black {
        didSet {
            for borderNode: SKShapeNode in borderNodes {
                borderNode.fillColor = borderColor
                borderNode.strokeColor = borderColor
            }
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
            for textNode: SKShapeNode in textNodes {
                textNode.fillColor = textColor
            }
        }
    }
    
    override var fontColor: UIColor? {
        didSet {
            if fontColor != nil {
                if fontColor != UIColor.clear {
                    textColor = fontColor!
                    super.fontColor = UIColor.clear
                    Swift.print("Please avoid using fontColor to set text color of SKOutlineLabelNodes")
                }
            }
        }
    }
    
    override var text: String? {
        didSet {
            drawBorder()
        }
    }
    
    override var zPosition: CGFloat {
        didSet {
            for i in 0 ..< borderNodes.count {
                borderNodes[i].zPosition = zPosition + CGFloat(i * 2)
            }
            
            for i in 0 ..< textNodes.count {
                textNodes[i].zPosition = zPosition + CGFloat(i + 1) * 2
            }
        }
    }
    
    func unifiedInit() {
        fontColor = UIColor.white
    }
    
    override init() {
        super.init()
        
        unifiedInit()
    }
    
    override init(fontNamed fontName: String?) {
        super.init(fontNamed: fontName)
        
        unifiedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBorder() {
        while borderNodes.count > 0 {
            borderNodes.removeFirst().removeFromParent()
        }
        
        while textNodes.count > 0 {
            textNodes.removeFirst().removeFromParent()
        }
        
        if text != nil && fontName != nil {
            let borderFont: CTFont = CTFontCreateWithName(fontName! as CFString, fontSize, nil)
            
            var chars: [UniChar] = []
            
            for codeUnit in text!.utf16 {
                chars.append(codeUnit)
            }
            
            var glyphs: [CGGlyph] = Array(repeating: 0, count: chars.count)
            let gotGlyphs: Bool = CTFontGetGlyphsForCharacters(borderFont, chars, &glyphs, chars.count)
            
            if gotGlyphs {
                let defaultTransformation: CGSize = CGSize(width: frame.size.width / 2 - borderWidth / 2, height: frame.size.height / 2 - borderWidth / 2)
                
                var advances: [CGSize] = Array(repeating: CGSize.zero, count: chars.count)
                CTFontGetAdvancesForGlyphs(borderFont, CTFontOrientation.horizontal, glyphs, &advances, chars.count)
                
                var xPosition: CGFloat = 0
                
                var shiftLeft: CGFloat = 0
                
                for i in 0 ..< chars.count {
                    let letter: CGPath? = CTFontCreatePathForGlyph(borderFont, glyphs[i], nil)
                    
                    if letter != nil {
                        let borderNode: SKShapeNode = SKShapeNode(path: letter!)
                        borderNode.position = CGPoint(x: xPosition - defaultTransformation.width - shiftLeft, y: -defaultTransformation.height)
                        borderNode.fillColor = borderColor
                        borderNode.strokeColor = borderColor
                        borderNode.lineWidth = borderWidth * 2
                        borderNode.lineJoin = CGLineJoin.miter
                        borderNodes.append(borderNode)
                        addChild(borderNode)
                        
                        let textNode: SKShapeNode = SKShapeNode(path: letter!)
                        textNode.position = borderNode.position
                        textNode.fillColor = textColor
                        textNode.strokeColor = UIColor.clear
                        textNode.lineWidth = 0
                        textNodes.append(textNode)
                        addChild(textNode)
                    }
                    
                    xPosition += advances[i].width
                    shiftLeft += fontSize / 10
                }
            }
        }
    }
    
    func createBorderPathForText() -> CGPath? {
        if text != nil && fontName != nil {
            let borderFont: CTFont = CTFontCreateWithName(fontName! as CFString, fontSize, nil)
            
            var chars: [UniChar] = []
            
            for codeUnit in text!.utf16 {
                chars.append(codeUnit)
            }
            
            var glyphs: [CGGlyph] = Array(repeating: 0, count: chars.count)
            let gotGlyphs: Bool = CTFontGetGlyphsForCharacters(borderFont, chars, &glyphs, chars.count)
            
            if gotGlyphs {
                let defaultTransformation: CGSize = CGSize(width: frame.size.width / 2 - borderWidth / 2, height: frame.size.height / 2 - borderWidth / 2)
                
                var advances: [CGSize] = Array(repeating: CGSize.zero, count: chars.count)
                CTFontGetAdvancesForGlyphs(borderFont, CTFontOrientation.horizontal, glyphs, &advances, chars.count)
                
                let letters: CGMutablePath = CGMutablePath()
                var xPosition: CGFloat = 0
                
                var shiftLeft: CGFloat = 0
                
                for i in 0 ..< chars.count {
                    let letter: CGPath? = CTFontCreatePathForGlyph(borderFont, glyphs[i], nil)
                    let t: CGAffineTransform = CGAffineTransform(translationX: xPosition - defaultTransformation.width - shiftLeft, y: -defaultTransformation.height)
                    
                    if letter != nil {
                        letters.addPath(letter!, transform: t)
                    }
                    
                    xPosition += advances[i].width
                    shiftLeft += fontSize / 10
                }
                
                return letters
            }
        }
        
        return nil
    }
    
}
