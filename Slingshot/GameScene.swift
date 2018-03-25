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


struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0x1 << 1
    
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
    
    
    override func sceneDidLoad() {
        addChild(worldNode)
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
        createScreen()
        createPlayer()
        setUpTouchScreenToStartLabel()
        
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
            print("Obstacle 1")
        case 2:
            print("Obstacle 2")
        case 3:
            print("Obstacle 3")
        default:
            print("Default Obstacle")
        }
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
        
        if startGame && CGFloat(dt) >= random(min: 2, max: 5) {
            self.lastUpdateTime = currentTime
            randomObstacle(obsticle: Int(arc4random_uniform(3) + 1))
        }
    }
}
