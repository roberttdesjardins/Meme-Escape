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

class GameScene: SKScene, SKPhysicsContactDelegate {
    let worldNode = SKNode()
    
    private var startLabel: SKLabelNode! = nil
    private var lastUpdateTime : TimeInterval = 0
    private var startGame: Bool = false
    private var counter: Int = 0
    
    
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
        player.initPlayer()
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
            let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [1, 3, 5])
            obstacle3(order: shuffled as! [CGFloat])
        case 4:
            obstacle4()
        case 5:
            print("Obstacle 5")
        case 6:
            print("Obstacle 6")
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
        let obs = Wall(imageNamed: "white_pixel")
        obs.initWall(position: CGPoint(x: size.width + obs.size.width/2, y: random(min: obs.size.height/2, max: size.height - obs.size.height/2)))
        worldNode.addChild(obs)
        
        obs.moveSprite(location: CGPoint(x: -obs.size.width/2, y: obs.position.y), duration: 2.2)
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
        let obs = WednesdayFrog(imageNamed: "myDudes")
        obs.initWednesdayMyDudes()
        worldNode.addChild(obs)
        
        obs.makeFrogMove()
    }
    
    func obstacle3(order: [CGFloat]) {
        let timeDuration = TimeInterval(2.5)
        let pos1 = CGPoint(x: self.size.width * (order[0]/6), y: self.size.height/2)
        let pos2 = CGPoint(x: self.size.width * (order[1]/6), y: self.size.height/2)
        let pos3 = CGPoint(x: self.size.width * (order[2]/6), y: self.size.height/2)
        let actionOmaeSound = SKAction.run {
            self.playSoundFile(soundFile: "omae", duration: timeDuration)
        }
        let actionWarning = SKAction.run {
            self.createWarningArea(width: self.size.width/10, height: self.size.height, position: pos1, duration: 2.0)
            self.createWarningArea(width: self.size.width/10, height: self.size.height, position: pos2, duration: 3.0)
            self.createWarningArea(width: self.size.width/10, height: self.size.height, position: pos3, duration: 4.0)
        }
        let actionWait = SKAction.wait(forDuration: timeDuration)
        
        let actionNaniSound = SKAction.run {
            self.playSoundFile(soundFile: "nani", duration: timeDuration)
        }
        let actionWaitBetweenLaser = SKAction.wait(forDuration: 1.0)
        
        let actionLaser1 = SKAction.run {
            self.createLaserBeam(position: pos1)
        }
        let actionLaser2 = SKAction.run {
            self.createLaserBeam(position: pos2)
        }
        let actionLaser3 = SKAction.run {
            self.createLaserBeam(position: pos3)
        }
        
        
        worldNode.run(SKAction.sequence([
            actionOmaeSound,
            actionWarning,
            actionWait,
            actionNaniSound,
            actionLaser1,
            actionWaitBetweenLaser,
            actionLaser2,
            actionWaitBetweenLaser,
            actionLaser3
            ]))
    }
    
    func createLaserBeam(position: CGPoint) {
        let laser = Laser(imageNamed: "teslaColor1")
        laser.initLaser(position: position)
        self.worldNode.addChild(laser)
        laser.runGif()
        self.playSoundFile(soundFile: "laserbeamsound", duration: 5.0)
    }
    
    func createWarningArea(width: CGFloat, height: CGFloat, position: CGPoint, duration: TimeInterval) {
        let warning = SKSpriteNode(imageNamed: "warningNoBorder")
        warning.size = CGSize(width: width, height: height)
        warning.position = position
        worldNode.addChild(warning)
        
        let warningBorder = SKShapeNode(rectOf: CGSize(width: width, height: height))
        warningBorder.fillColor = .clear
        warningBorder.lineWidth = 5
        warningBorder.strokeColor = .red
        warningBorder.alpha = 0.5
        warning.addChild(warningBorder)
        
        let actionWait = SKAction.wait(forDuration: duration)
        let actionWaitDone = SKAction.removeFromParent()
        warning.run(SKAction.sequence([actionWait, actionWaitDone]))
    }
    
    func obstacle4() {
        let triangle = Illuminati(imageNamed: "Illuminati")
        let randomXPos = size.width/2 + (size.width/2 + triangle.size.width/2) * CGFloat.randomSign
        let randomYPos = size.height/2 + (size.height/2 + triangle.size.height/2) * CGFloat.randomSign
        let randomPosition = CGPoint(x: randomXPos, y: randomYPos)
        triangle.initTriangle(position: randomPosition)
        triangle.rotateTriangle()
        self.worldNode.addChild(triangle)
        
        let moveDuration = TimeInterval(10.0)
        
        triangle.moveForDuration(time: moveDuration)
        playSoundFile(soundFile: "illuminati", duration: moveDuration)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let player = worldNode.childNode(withName: GameData.shared.kPlayerName) as? Player {
            startLabel.removeFromParent()
            startGame = true
            player.position = pos
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let player = worldNode.childNode(withName: GameData.shared.kPlayerName) as? Player {
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
        if ob1.name == GameData.shared.kPlayerName && ob2.name == GameData.shared.kObstacleName {
            gameOverSceneLoad(view: view!)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == GameData.shared.kPlayerName {
            collisionBetween(ob1: nodeA, ob2: nodeB)
        } else if nodeB.name == GameData.shared.kPlayerName {
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
            randomObstacle(obsticle: Int(arc4random_uniform(4) + 1))
            //randomObstacle(obsticle: 4)
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

