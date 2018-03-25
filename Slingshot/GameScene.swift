//
//  GameScene.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-24.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation


public extension CGFloat {
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0x1 << 1
    static let Obstacle: UInt32 = 0x1 << 2
    
    static let Edge: UInt32 = 0x1 << 25
    static let All: UInt32 = UInt32.max
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let worldNode = SKNode()
    
    private var startLabel: SKLabelNode! = nil
    private var lastUpdateTime : TimeInterval = 0
    private var startGame: Bool = false
    private var counter: Int = 0
    
    private var kPlayerName = "playerName"
    private var kObstacleName = "obstacleName"
    
    
    override func sceneDidLoad() {
        addChild(worldNode)
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
        createScreen()
        createPlayer()
        setUpTouchScreenToStartLabel()
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    }
    
    func createScreen() {
        scene?.scaleMode = SKSceneScaleMode.resizeFill
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody!.categoryBitMask = PhysicsCategory.Edge
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
    
    
    func createPlayer() {
        let player:Player = Player(imageNamed: "circle")
        player.size = CGSize(width: 40, height: 40)
        player.zPosition = 6
        player.name = kPlayerName
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        player.physicsBody!.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Edge
        player.physicsBody?.collisionBitMask = PhysicsCategory.Edge
        player.position = CGPoint(x: size.width * (1/2), y: size.height * (1/6))
        worldNode.addChild(player)
    }
    
    func setUpTouchScreenToStartLabel() {
        startLabel = SKLabelNode(fontNamed: "Avenir")
        startLabel.fontSize = 45
        startLabel.fontColor = SKColor.white
        startLabel.text = "Touch To Start. Don't let go!"
        startLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        worldNode.addChild(startLabel)
    }
    
    func randomObstacle(obsticle: Int) {
        switch obsticle {
        case 1:
            obstacle1()
        case 2:
            obstacle2()
        case 3:
            print("Obstacle 3")
        default:
            print("Default Obstacle")
        }
    }
    
    func obstacle1() {
        worldNode.run(SKAction.repeat(SKAction.sequence([
            SKAction.run {
                self.addWall()
            },
            SKAction.wait(forDuration: TimeInterval(random(min: 0.5, max: 1.0)))]), count: 5))
    }
    
    func addWall() {
        let obs = SKSpriteNode(imageNamed: "white_pixel")
        obs.name = kObstacleName
        obs.size = CGSize(width: 30, height: size.height * (1/2))
        obs.position = CGPoint(x: size.width + obs.size.width/2, y: random(min: obs.size.height/2, max: size.height - obs.size.height/2))
        obs.zPosition = 1
        
        obs.physicsBody = SKPhysicsBody(rectangleOf: obs.size)
        obs.physicsBody?.isDynamic = false
        obs.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        obs.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        obs.physicsBody?.collisionBitMask = PhysicsCategory.None
        worldNode.addChild(obs)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(3.0))
        let actionMove = SKAction.move(to: CGPoint(x: -obs.size.width/2, y: obs.position.y), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        obs.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func obstacle2() {
        let timeDuration = TimeInterval(3.0)
        let actionWednesdaySound = SKAction.run {
            self.playSoundFile(soundFile: "wednesday", duration: timeDuration)
        }
        let actionWait = SKAction.wait(forDuration: timeDuration)
        let actionMyDudesSound = SKAction.run {
            self.playSoundFile(soundFile: "myDudes", duration: 5.0)
        }
        let actionRunFrogs = SKAction.repeat(SKAction.sequence([SKAction.run {self.addWednesday()},SKAction.wait(forDuration: TimeInterval(random(min: 0.1, max: 0.2)))]), count: 25)
        
        worldNode.run(SKAction.sequence([
            actionWednesdaySound,
            actionWait,
            actionMyDudesSound,
            actionRunFrogs
            ]))
    }
    
    func addWednesday() {
        let obs = SKSpriteNode(imageNamed: "myDudes")
        obs.name = kObstacleName
        obs.size = CGSize(width: 65, height: 65)
        obs.position = CGPoint(x: size.width/2, y: -obs.size.height/2)
        obs.zPosition = 2
        obs.zRotation = random(min: 0, max: 6.28319)
        
        obs.physicsBody = SKPhysicsBody(texture: obs.texture!, size: obs.size)
        obs.physicsBody?.isDynamic = true
        obs.physicsBody?.affectedByGravity = true
        obs.physicsBody?.allowsRotation = true
        obs.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        obs.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        obs.physicsBody?.collisionBitMask = PhysicsCategory.None
        worldNode.addChild(obs)
        
        let randomDX = random(min: -250, max: 250)
        let randomDY = random(min: 450, max: 650)
        obs.physicsBody?.applyForce(CGVector(dx: randomDX, dy: randomDY))
        
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2 * CGFloat.randomSign, duration: TimeInterval(random(min: 0.5, max: 3.0)))
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        obs.run(repeatRotation)
        
        let actionWait = SKAction.wait(forDuration: 5)
        let actionMoveDone = SKAction.removeFromParent()
        obs.run(SKAction.sequence([actionWait, actionMoveDone]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let player = worldNode.childNode(withName: kPlayerName) as? Player {
            startLabel.removeFromParent()
            startGame = true
            player.position = pos
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let player = worldNode.childNode(withName: kPlayerName) as? Player {
            player.position = pos
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        // Game ends when player lifts finger up
        gameOverSceneLoad(view: view!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    
    // Called when there is a collision between two nodes.
    func collisionBetween(ob1: SKNode, ob2: SKNode){
        if ob1.name == kPlayerName && ob2.name == kObstacleName {
            gameOverSceneLoad(view: view!)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == kPlayerName {
            collisionBetween(ob1: nodeA, ob2: nodeB)
        } else if nodeB.name == kPlayerName {
            collisionBetween(ob1: nodeB, ob2: nodeA)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if startGame {
            counter = counter + 1
        }
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        if startGame && CGFloat(dt) >= random(min: 4, max: 5) {
            self.lastUpdateTime = currentTime
            randomObstacle(obsticle: Int(arc4random_uniform(3) + 1))
        }
    }

    func playSoundFile(soundFile: String, duration: TimeInterval) {
        let audioNode = SKAudioNode(fileNamed: soundFile)
        audioNode.autoplayLooped = false
        addChild(audioNode)
        let playAction = SKAction.play()
        audioNode.run(SKAction.sequence([playAction, SKAction.wait(forDuration: duration), SKAction.removeFromParent()]))
    }
}

