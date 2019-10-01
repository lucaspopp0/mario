//
//  SKButtonNode.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/28/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class SKButtonNode: SKSpriteNode {
    
    // Displays the text
    private let titleNode: SKLabelNode = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 15).fontName)
    
    // Displays the shape of the button
    private let shapeNode: SKShapeNode = SKShapeNode()
    
    // Action/target pairs for touchDown
    internal var touchDownTargets: [AnyObject] = []
    internal var touchDownActions: [Selector] = []
    
    // Action/target pairs for touchUp
    internal var touchUpTargets: [AnyObject] = []
    internal var touchUpActions: [Selector] = []
    
    // Action/target pairs for touchExit
    internal var touchExitTargets: [AnyObject] = []
    internal var touchExitActions: [Selector] = []
    
    var isDown: Bool = false
    
    var backgroundColor: UIColor! {
        didSet {
            shapeNode.fillColor = backgroundColor
        }
    }
    
    var borderColor: UIColor = UIColor.clear {
        didSet {
            shapeNode.strokeColor = borderColor
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            shapeNode.path = CGPath(roundedRect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        }
    }
    
    var title: String = "" {
        didSet {
            titleNode.text = title
        }
    }
    
    override var size: CGSize {
        didSet {
            shapeNode.path = CGPath(roundedRect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        }
    }
    
    var font: UIFont! {
        didSet {
            titleNode.fontName = font.fontName
            titleNode.fontSize = font.pointSize
        }
    }
    
    var textColor: UIColor! {
        didSet {
            titleNode.fontColor = textColor
        }
    }
    
    init(font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        super.init(texture: nil, color: UIColor.clear, size: CGSize.zero)
        
        shapeNode.isUserInteractionEnabled = false
        
        shapeNode.path = CGPath(roundedRect: CGRect.zero, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        
        self.backgroundColor = backgroundColor
        shapeNode.fillColor = backgroundColor
        shapeNode.strokeColor = UIColor.clear
        
        self.font = font
        self.textColor = textColor
        
        isUserInteractionEnabled = true
        
        titleNode.fontName = font.fontName
        titleNode.fontSize = font.pointSize
        titleNode.fontColor = textColor
        
        titleNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        titleNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        addChild(shapeNode)
        addChild(titleNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTargetForTouchDown(_ target: AnyObject, with action: Selector) {
        touchDownTargets.append(target)
        touchDownActions.append(action)
    }
    
    func addTargetForTouchUp(_ target: AnyObject, with action: Selector) {
        touchUpTargets.append(target)
        touchUpActions.append(action)
    }
    
    func addTargetForTouchExit(_ target: AnyObject, with action: Selector) {
        touchExitTargets.append(target)
        touchExitActions.append(action)
    }
    
    func clearActions() {
        touchDownTargets.removeAll()
        touchDownActions.removeAll()
        
        touchUpTargets.removeAll()
        touchUpActions.removeAll()
        
        touchExitTargets.removeAll()
        touchExitActions.removeAll()
    }
    
    func touchBegin() {
        isDown = true
        
        for i in 0 ..< touchDownTargets.count {
            let _ = touchDownTargets[i].perform(touchDownActions[i])
        }
    }
    
    func touchUp() {
        isDown = false
        
        for i in 0 ..< touchUpTargets.count {
            let _ = touchUpTargets[i].perform(touchUpActions[i])
        }
    }
    
    func touchExit() {
        isDown = false
        
        for i in 0 ..< touchExitTargets.count {
            let _ = touchExitTargets[i].perform(touchExitActions[i])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location: CGPoint = touches.first!.location(in: self)
        
        if shapeNode.path != nil && shapeNode.path!.contains(location) {
            touchBegin()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location: CGPoint = touches.first!.location(in: self)
        let previousLocation: CGPoint = touches.first!.previousLocation(in: self)
        
        if shapeNode.path != nil && shapeNode.path!.contains(previousLocation) && !shapeNode.path!.contains(location) {
            touchExit()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location: CGPoint = touches.first!.location(in: self)
        
        if shapeNode.path != nil && shapeNode.path!.contains(location) {
            touchUp()
        }
    }
    
    func sizeToFit() {
        size = titleNode.frame.size
    }
    
}
