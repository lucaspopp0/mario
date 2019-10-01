//
//  Player.swift
//  Platformer 2
//
//  Created by Lucas Popp on 12/27/16.
//  Copyright © 2016 Lucas Popp. All rights reserved.
//

import SpriteKit

class Player: Character, Walking, Jumping {
    
    static var RAINBOW_OFFSET: CGFloat = 0
    
    enum Power {
        
        case none
        case fire
        case invincibility
        
    }
    
    var spriteDirection: WalkDirection = WalkDirection.right  {
        didSet {
            updateSprite()
        }
    }
    
    var isRunning: Bool {
        get {
            return walkDirection != WalkDirection.none
        }
    }
    
    var isJumping: Bool {
        get {
            return shouldJump || jumpCancelled
        }
    }
    
    var isGroundPounding: Bool {
        get {
            return !onGround && shouldGroundPound
        }
    }
    
    var currentColumn: Int?
    var currentRow: Int?
    
    var lastColumn: Int?
    var lastRow: Int?
    
    var walkDirection: WalkDirection = WalkDirection.none
    
    var walkSpeed: CGFloat = 800
    
    var jumpSpeed: CGFloat = 250
    var shouldJump: Bool = false {
        didSet {
            updateSprite()
        }
    }
    
    var shouldGroundPound: Bool = false {
        didSet {
            updateSprite()
        }
    }
    
    var jumpCancelled: Bool = false {
        didSet {
            updateSprite()
        }
    }
    
    var lastWallJumpDirection: WalkDirection = WalkDirection.none
    
    var isSliding: Bool = false {
        didSet {
            updateSprite()
        }
    }
    
    var isBig: Bool = false {
        didSet {
            updateSprite()
        }
    }
    
    var isCelebrating: Bool = false
    
    var canDie: Bool = true
    
    var power: Power = Power.none {
        didSet {
            updateSprite()
        }
    }
    
    override var onGround: Bool {
        get {
            return super.onGround && !(collidingWithBlock(toThe: TileDirection.bottom) && shouldGroundPound && velocity.y == 0)
        }
    }
    
    var lastOnGround: Bool = true
    var footstepInterval: Double = 0.3
    var checkingFootsteps: Bool = false
    
    var spriteIndex: CGFloat = 0
    
    // MARK: Sounds
    let soundManager: SoundManager = SoundManager()
    
    var levelClear: Sound?
    
    var jumpSound: Sound?
    var wallJumpSound: Sound?
    var powerUpSound: Sound?
    var powerDownSound: Sound?
    var kickSound: Sound?
    var stompSound: Sound?
    
    var bumpBlockSound: Sound?
    
    var groundLandSound: Sound?
    var blockLandSound: Sound?
    var groundStepSound: Sound?
    var blockStepSound: Sound?
    
    var fireballSound: Sound?
    var starmanEndingSound: Sound?
    var starmanMusic: Sound?
    
    var dieSound: Sound?
    
    init(position: CGPoint) {
        super.init(image: #imageLiteral(resourceName: "Mario Jumping - Right"), position: position)
        
        minimumSpeedX = -120
        maximumSpeedX = 120
        minimumSpeedY = -450
        maximumSpeedY = 250
        
        zPosition = 2
        
        behaviors.append(WalkBehavior(entity: self))
        behaviors.append(JumpBehavior(entity: self, wallJumpEnabled: true))
        
        levelClear = soundManager.loadSound(url: SoundManager.urls["Level Clear"]!)
        
        jumpSound = soundManager.loadSound(url: SoundManager.urls["Jump"]!)
        wallJumpSound = soundManager.loadSound(url: SoundManager.urls["Wall Jump"]!)
        
        powerUpSound = soundManager.loadSound(url: SoundManager.urls["Power Up"]!)
        powerDownSound = soundManager.loadSound(url: SoundManager.urls["Power Down"]!)
        kickSound = soundManager.loadSound(url: SoundManager.urls["Kick"]!)
        stompSound = soundManager.loadSound(url: SoundManager.urls["Stomp"]!)
        
        bumpBlockSound = soundManager.loadSound(url: SoundManager.urls["Bump Block"]!)
        
        groundLandSound = soundManager.loadSound(url: SoundManager.urls["Ground Land"]!)
        blockLandSound = soundManager.loadSound(url: SoundManager.urls["Block Land"]!)
        groundStepSound = soundManager.loadSound(url: SoundManager.urls["Ground Step"]!)
        blockStepSound = soundManager.loadSound(url: SoundManager.urls["Block Step"]!)
        
        fireballSound = soundManager.loadSound(url: SoundManager.urls["Fireball"]!)
        starmanEndingSound = soundManager.loadSound(url: SoundManager.urls["Starman Ending"]!)
        starmanMusic = soundManager.loadSound(url: SoundManager.urls["Starman Music"]!)
        starmanMusic?.player.numberOfLoops = -1
        
        dieSound = soundManager.loadSound(url: SoundManager.urls["Player Die"]!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateSprite() {
        let playerBottom: CGPoint = CGPoint(x: position.x, y: position.y - (size.height / 2))
        
        var imageName: String = ""
        
        if power == Power.fire {
            imageName = "Fire "
        }
        
        if isBig {
            imageName = "\(imageName)Mario"
        } else {
            imageName = "Small \(imageName)Mario"
        }
        
        if !isAlive {
            imageName = "\(imageName) Dead"
        } else {
            if isSliding {
                imageName = "\(imageName) Sliding"
            } else if isCelebrating {
                imageName = "\(imageName) Celebrating"
            } else if isGroundPounding {
                imageName = "\(imageName) Crouching"
            } else if isJumping {
                var onWall: Bool = false
                
                if walkDirection == WalkDirection.right {
                    let collInfo: CollisionInfo = collisionInfo(toThe: TileDirection.right)
                    
                    if collInfo.colliding && collInfo.type.isSolid {
                        onWall = true
                    } else if isBlock(toThe: TileDirection.right) {
                        onWall = true
                    }
                } else if walkDirection == WalkDirection.left {
                    let collInfo: CollisionInfo = collisionInfo(toThe: TileDirection.left)
                    
                    if collInfo.colliding && collInfo.type.isSolid {
                        onWall = true
                    } else if isBlock(toThe: TileDirection.left) {
                        onWall = true
                    }
                }
                
                if onWall {
                    imageName = "\(imageName) Wall Sliding"
                } else {
                    imageName = "\(imageName) Jumping"
                }
            } else if isRunning {
                imageName = "\(imageName) Running"
                
                if isBig {
                    imageName = "\(imageName) \(animationString(spriteTime: MVCManager.data.universalSpriteIndex, strings: ["1", "2", "3", "4", "5", "6"], frameTime: 0.05))"
                } else {
                    imageName = "\(imageName) \(animationString(spriteTime: MVCManager.data.universalSpriteIndex, strings: ["1", "2", "3", "4"], frameTime: 0.1))"
                }
            } else {
                imageName = "\(imageName) Standing"
            }
            
            if !isCelebrating {
                if spriteDirection == WalkDirection.left {
                    imageName = "\(imageName) - Left"
                } else {
                    imageName = "\(imageName) - Right"
                }
            }
        }
        
        if let spriteImage: UIImage = UIImage(named: imageName) {
            if power == Power.invincibility {
                if let rainbowImage: UIImage = spriteImage.withRainbow(offsetBy: Player.RAINBOW_OFFSET) {
                    displaySprite(rainbowImage)
                }
            } else {
                displaySprite(spriteImage)
            }
            
            position = CGPoint(x: playerBottom.x, y: playerBottom.y + (size.height / 2))
        }
    }
    
    func throwFireball() {
        if power == Power.fire && isBig {
            var fireball: Fireball!
            
            fireballSound?.player.play()
            
            if spriteDirection == WalkDirection.left {
                fireball = Fireball(position: CGPoint.zero, direction: PaceDirection.left)
                fireball.position = CGPoint(x: position.x - (size.width / 2) - (fireball.size.width / 2), y: position.y)
            } else {
                fireball = Fireball(position: CGPoint.zero, direction: PaceDirection.right)
                fireball.position = CGPoint(x: position.x + (size.width / 2) + (fireball.size.width / 2), y: position.y)
            }
            
            MVCManager.data.scene?.currentLevelMap?.addEntity(fireball)
        }
    }
    
    func walkLeft() {
        walkDirection = WalkDirection.left
        spriteDirection = WalkDirection.left
    }
    
    func walkRight() {
        walkDirection = WalkDirection.right
        spriteDirection = WalkDirection.right
    }
    
    func walkNone() {
        walkDirection = WalkDirection.none
    }
    
    @objc func aPressed() {
        throwFireball()
        
        if let scene: GameScene = MVCManager.data.scene {
            if let map: LevelMap = scene.currentLevelMap {
                scene.attemptDoorEntry(
                    map,
                    column: Int(floor(desiredPosition.x / GameScene.TILE_SIZE.width)),
                    row: Int(floor(desiredPosition.y / GameScene.TILE_SIZE.height)))
            }
        }
    }
    @objc  func jump() {
        shouldJump = true
    }
    
    @objc func stopJumping() {
        shouldJump = false
        jumpCancelled = true
    }
    
    func groundPound() {
        shouldGroundPound = true
    }
    
    override func injure() {
        if canDie {
            if isBig {
                if power != Power.none {
                    power = Power.none
                } else {
                    isBig = false
                }
                
                canDie = false
                
                powerDownSound?.player.play()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 + 2, execute: {
                    self.canDie = true
                })
            } else {
                die()
            }
        }
    }
    
    override func die() {
        isAlive = false
        
        MVCManager.data.lifeCount -= 1
        
        MVCManager.data.scene?.updating = false
        
        updateSprite()
        
        MVCManager.data.scene?.currentLevelMap?.music?.player.stop()
        dieSound?.player.play()
        
        let soundDuration = dieSound?.player.duration ?? 0
        
        let action: SKAction = SKAction.sequence([SKAction.moveBy(x: 0, y: 50, duration: 0.5), SKAction.moveBy(x: 0, y: -position.y - size.height - 50, duration: 1)])
        self.run(action)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + soundDuration) {
            super.die()
            MVCManager.controller.tryAgain()
        }
    }
    
    func checkFootstep() {
        checkingFootsteps = true
        
        if onGround {
            if walkDirection != WalkDirection.none {
                if isBlock(toThe: TileDirection.bottom) {
                    blockStepSound?.player.play()
                } else {
                    groundStepSound?.player.play()
                }
            }
        }
        
        if velocity.x != 0 {
            footstepInterval = 0.25 / Double(abs(velocity.x))
        } else {
            footstepInterval = 0.2
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + footstepInterval, execute: {
//            self.checkFootstep()
        })
    }
    
    func reset() {
        isAlive = true
        velocity = CGPoint.zero
        walkDirection = WalkDirection.none
        spriteDirection = WalkDirection.right
        shouldJump = false
        jumpCancelled = false
        lastWallJumpDirection = WalkDirection.none
        
        isSliding = false
        isCelebrating = false
        
        if power == Power.invincibility {
            power = Power.none
        }
        
        behaviors.removeAll()
        behaviors.append(WalkBehavior(entity: self))
        behaviors.append(JumpBehavior(entity: self, wallJumpEnabled: true))
    }
    
    override func update(timeStep: CGFloat) {
        super.update(timeStep: timeStep)
        
        Player.RAINBOW_OFFSET += timeStep
        
        while Player.RAINBOW_OFFSET >= 1 {
            Player.RAINBOW_OFFSET -= 1
        }
        
        spriteIndex += timeStep
        
        if position.y < 0 {
            die()
            return
        }
        
        if MVCManager.data.scene != nil && MVCManager.data.scene!.currentLevelMap != nil {
            let entityScene: GameScene = MVCManager.data.scene!
            let map: LevelMap = entityScene.currentLevelMap!
            
            let entitiesToCheck: [Entity] = surroundingEntities()
            var goalPole: GoalPole?
            
            if !lastOnGround && shouldGroundPound {
                for entity: Entity in entitiesToCheck {
                    let playerRect: CGRect = collisionBoundingBox
                    let entityRect: CGRect = entity.collisionBoundingBox
                    
                    if entity is Block {
                        if CGRect(origin: CGPoint(x: playerRect.origin.x, y: 0), size: playerRect.size).intersects(CGRect(origin: CGPoint(x: entityRect.origin.x, y: 0), size: entityRect.size)) {
                            if playerRect.origin.y - (entityRect.origin.y + entityRect.size.height) < -velocity.y * 2 {
                                (entity as! Block).dropItem(toMap: map)
                            }
                        }
                    }
                }
            }
            
            for entity: Entity in entitiesToCheck {
                if entity is GoalPole {
                    goalPole = entity as? GoalPole
                }
            }
            
            if goalPole != nil {
                if (!isBig && goalPole!.position.x - position.x <= 7) || (isBig && goalPole!.position.x - position.x <= 6) {
                    MVCManager.data.scene?.updating = false
                    isSliding = true
                    
                    MVCManager.data.scene?.currentLevelMap?.music?.player.pause()
                    
                    MVCManager.controller.disableControls()
                    
                    let slide: SKAction = SKAction.moveBy(x: 0, y: (goalPole!.position.y - (goalPole!.size.height / 2)) - position.y + (size.height / 2), duration: 0.4)
                    let bowserFlagAction: SKAction = SKAction.move(to: CGPoint(x: goalPole!.bowserFlag.position.x, y: goalPole!.position.y - 16 - (goalPole!.size.height + goalPole!.bowserFlag.size.width) / 2), duration: 0.4)
                    let marioFlagAction: SKAction = SKAction.move(to: goalPole!.bowserFlag.position, duration: 0.4)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.run(slide)
                        
                        goalPole!.slideSound?.player.play()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + slide.duration, execute: {
                            goalPole!.bowserFlag.run(bowserFlagAction)
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + bowserFlagAction.duration, execute: {
                                goalPole!.marioFlag.run(marioFlagAction)
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + marioFlagAction.duration, execute: {
                                    self.levelClear?.player.play()
                                    
                                    self.position.x += GameScene.TILE_SIZE.width * 4
                                    self.position.y -= GameScene.TILE_SIZE.height
                                    
                                    self.shouldJump = false
                                    self.jumpCancelled = false
                                    
                                    self.isCelebrating = true
                                    
                                    self.isSliding = false
                                    
                                    self.updateSprite()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (self.levelClear?.player.duration ?? 0), execute: {
                                        if let currentLevel: GameLevel = MVCManager.data.currentLevel {
                                            let currentWorld: Int = currentLevel.world
                                            
                                            MVCManager.controller.loadMap(named: "W\(currentWorld)")
                                            MVCManager.data.worldMap?.positionPlayerForLevel(level: currentLevel)
                                        }
                                        
                                        MVCManager.data.currentLevel = nil
                                    })
                                })
                            })
                        })
                    })
                    
                    return
                }
            }
            
            for entity: Entity in entitiesToCheck {
                let playerRect: CGRect = collisionBoundingBox
                let entityRect: CGRect = entity.collisionBoundingBox
                
                if entity is MovingPlatform {
                    if CGRect(origin: CGPoint(x: entityRect.origin.x, y: 0), size: entityRect.size).intersects(CGRect(origin: CGPoint(x: playerRect.origin.x, y: 0), size: playerRect.size)) {
                        if round(playerRect.origin.y, places: 1) == round(entityRect.origin.y + entityRect.size.height, places: 1) {
                            (entity as! MovingPlatform).isMoving = false
                            (entity as! MovingPlatform).isFalling = true
                            (entity as! MovingPlatform).affectedByGravity = true
                        }
                    }
                } else if playerRect.intersects(entityRect) {
                    let intersection: CGRect = playerRect.intersection(entityRect)
                    
                    if entity is Coin {
                        if (entity as! Coin).usable && !(entity as! Coin).used {
                            (entity as! Coin).sound?.player.play()
                            MVCManager.data.scene?.currentLevelMap?.removeEntity(entity)
                            MVCManager.data.coinCount += 1
                            
                            (entity as! Coin).used = true
                        }
                    } else if entity is StarCoin {
                        if !(entity as! StarCoin).used {
                            (entity as! StarCoin).sound?.player.play()
                            
                            (entity as! StarCoin).used = true
                        }
                    } else if !lastOnGround && shouldGroundPound && entity is BreakableBlock && position.y > entity.position.y {
                        (entity as! BreakableBlock).breakBlock(map)
                    } else if entity is Enemy && (entity as! Enemy).isAlive {
                        if power == Power.invincibility {
                            (entity as! Enemy).die()
                            stompSound?.player.play()
                        } else {
                            var playerLanding: Bool = velocity.y < 0 && position.y > entity.position.y
                            
                            if playerLanding {
                                if intersection.height < intersection.width {
                                    playerLanding = true
                                } else {
                                    if walkDirection == WalkDirection.right && (entity as! Enemy).velocity.x < velocity.x {
                                        playerLanding = true
                                    } else if walkDirection == WalkDirection.left && (entity as! Enemy).velocity.x > velocity.x {
                                        playerLanding = true
                                    } else {
                                        playerLanding = false
                                    }
                                }
                            }
                            
                            
                            if (entity is Goomba || entity is KoopaTroopa || (entity is DryBones && !(entity as! DryBones).isInjured)) || (entity is BoomBoom && (entity as! BoomBoom).stage != BoomBoomStage.hurt) {
                                if entity is Goomba {
                                    if playerLanding {
                                        (entity as! Goomba).die()
                                        stompSound?.player.play()
                                    } else {
                                        injure()
                                    }
                                } else if entity is KoopaTroopa {
                                    if playerLanding {
                                        (entity as! KoopaTroopa).jumpedOn()
                                        
                                        stompSound?.player.play()
                                    } else {
                                        if (entity as! KoopaTroopa).inShell {
                                            if (entity as! KoopaTroopa).paceSpeed == 0 {
                                                (entity as! KoopaTroopa).moveShell()
                                                kickSound?.player.play()
                                                
                                                if position.x + (size.width / 2) < entity.position.x + (entity.size.width / 2) {
                                                    (entity as! KoopaTroopa).paceDirection = PaceDirection.right
                                                    entity.position.x += intersection.width
                                                } else {
                                                    (entity as! KoopaTroopa).paceDirection = PaceDirection.left
                                                    entity.position.x -= intersection.width
                                                }
                                            } else if ((entity as! KoopaTroopa).paceDirection == PaceDirection.left && walkDirection != WalkDirection.left) ||
                                                ((entity as! KoopaTroopa).paceDirection == PaceDirection.right && walkDirection != WalkDirection.right) {
                                                injure()
                                            }
                                        } else {
                                            injure()
                                        }
                                    }
                                } else if entity is DryBones {
                                    if playerLanding {
                                        (entity as! DryBones).injure()
                                        stompSound?.player.play()
                                    } else {
                                        injure()
                                    }
                                } else if entity is BoomBoom {
                                    if (entity as! BoomBoom).stage == BoomBoomStage.pacing {
                                        if playerLanding {
                                            (entity as! BoomBoom).injure()
                                        }
                                    }
                                }
                                
                                if playerLanding {
                                    if !isGroundPounding {
                                        velocity.y = jumpSpeed / 2
                                    }
                                    
                                    jumpCancelled = false
                                }
                            }
                        }
                    } else if entity is Firesphere {
                        injure()
                    } else if entity is PowerUp && (entity as! PowerUp).usable && !(entity as! PowerUp).used {
                        if entity is SuperMushroom {
                            isBig = true
                            powerUpSound?.player.play()
                        } else if entity is FireFlower {
                            isBig = true
                            power = Power.fire
                        } else if entity is OneUp {
                            MVCManager.data.lifeCount += 1
                        } else if entity is SuperStar {
                            power = Power.invincibility
                            
                            MVCManager.data.scene?.currentLevelMap?.music?.player.pause()
                            starmanMusic?.player.play()
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 7, execute: {
                                if self.power == Power.invincibility {
                                    self.starmanEndingSound?.player.play()
                                }
                            })
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 9, execute: {
                                if self.power == Power.invincibility {
                                    self.power = Power.none
                                    self.starmanMusic?.player.pause()
                                    MVCManager.data.scene?.currentLevelMap?.music?.player.play()
                                }
                            })
                        }
                        
                        (entity as! PowerUp).used = true
                        MVCManager.data.scene?.currentLevelMap?.removeEntity(entity)
                    }
                }
            }
            
            if collidingWithBlock(toThe: TileDirection.top) && velocity.y >= 0 {
                if let block: Block = block(toThe: TileDirection.top) {
                    block.spitItem(toMap: map)
                }
            }
        }
        
        MVCManager.data.scene?.checkPipes()
        
        if onGround && !lastOnGround {
            if isBlock(toThe: TileDirection.bottom) {
                blockLandSound?.player.play()
            } else {
                groundLandSound?.player.play()
            }
        }
        
        lastOnGround = onGround
        
        lastColumn = currentColumn
        lastRow = currentRow
        
        currentColumn = Int(floor(position.x / GameScene.TILE_SIZE.width))
        currentRow = Int(floor(position.y / GameScene.TILE_SIZE.height))
        
        updateSprite()
    }
    
}
