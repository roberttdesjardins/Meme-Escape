//
//  GameScene.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-24.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

// TODO:
// Hole in lasers
// Delayed death omae wa
// maze dungeon van darkholme
// You just got pranked, projectile moves faster towards player
// Dream- Projectiles change direction ever hesitation
// Slap - How can she slap
// YOU'RE TOO SLOW - SONICHU
// Sonics the name, speeds my game
// Move player sksprite towards finger really fast, so that you can create obstacles that prevent movement
// Donald trump build wall for obstacle 1 or waifu body pillows
// Oh shit, oh shit, oh shit
// Long cat goes up super long time, comes down other side
// Nothing personal kid, slash across screen, neckbeard in background - fedora?


import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let worldNode = SKNode()
    
    private var startLabel: SKLabelNode! = nil
    private var scoreLabel = SKLabelNode(fontNamed: "Avenir")
    private var lastUpdateTime : TimeInterval = 0
    private var startGame: Bool = false
    private var gameOver: Bool = false
    private var counter: Int = 0
    private var highScoreTable = SKLabelNode(fontNamed: "Avenir")
    private var highScoreBackground: SKSpriteNode! = nil
    
    private var firstTimeStart = true
    
    private var chaseArray: [SKSpriteNode] = []
    
    override func sceneDidLoad() {
        processGameData()
        addChild(worldNode)
        physicsWorld.contactDelegate = self
        self.lastUpdateTime = 0
        createScreen()
        createPlayer()
        createHighScoreTable()
        setUpTouchScreenToStartLabel()
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    }
    
    func processGameData() {
        GameData.shared.playerHighScore = UserDefaults.standard.getUserHighScores()
        GameData.shared.totalCredits = UserDefaults.standard.getUserCredits()
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
    
    
    func createHud() {
        scoreLabel.fontSize = 15
        scoreLabel.fontColor = SKColor.white
        scoreLabel.text = String("Score: \(GameData.shared.playerScore)")
        
        //TODO: Test this on iphoneX
        if UIScreen.main.nativeBounds.height == 2436.0 {
            scoreLabel.position = CGPoint(x: 0, y: size.height - (scoreLabel.frame.size.height + 22))
        } else {
            scoreLabel.position = CGPoint(x: 0, y: size.height - scoreLabel.frame.size.height)
        }
        
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.zPosition = 20
        addChild(scoreLabel)
    }
    
    func updateHud(){
        scoreLabel.text = String("Score: \(GameData.shared.playerScore)")
    }
    
    func createHighScoreTable() {
        highScoreTable.fontSize = size.width / 48
        highScoreTable.zPosition = 5
        highScoreTable.fontColor = SKColor.white
        highScoreTable.numberOfLines = 6
        highScoreTable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreTable.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        highScoreTable.text = "High Scores:\n"
        for highScore in GameData.shared.playerHighScore {
            highScoreTable.text?.append("\(highScore)\n")
        }
        
        addChild(highScoreTable)
        
        let scoreBGWidth = highScoreTable.frame.size.width + 40
        let scoreBGHeight = scoreBGWidth * 1.3042596349
        highScoreBackground = SKSpriteNode(imageNamed: "vertical-medium")
        highScoreBackground.zPosition = 2
        highScoreBackground.size = CGSize(width: scoreBGWidth, height: scoreBGHeight)
        highScoreBackground.position = CGPoint(x: size.width - highScoreBackground.size.width/2, y: size.height - highScoreBackground.size.height/2)
        addChild(highScoreBackground)
        
        highScoreTable.position = highScoreBackground.position
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
            obstacle5()
        case 6:
            obstacle6()
        case 7:
            obstacle7()
        case 8:
            obstacle8()
        case 9:
            obstacle9()
        default:
            print("Default Obstacle - shouldn't occur")
        }
    }
    
    
    // Creates a sequence of walls moving from the left or right of the screen
    func obstacle1() {
        let wallDirection = ["Left", "Right"].randomItem()
        
        worldNode.run(SKAction.repeat(SKAction.sequence([
            SKAction.run {
                self.addWall(direction: wallDirection!)
            },
            SKAction.wait(forDuration: TimeInterval(random(min: 0.5, max: 1.0)))]), count: 7))
    }
    
    func addWall(direction: String) {
        let obs = Wall(imageNamed: "white_pixel")
        if direction == "Right" {
            obs.initWall()
            obs.position = CGPoint(x: 0 - obs.size.width/2, y: random(min: obs.size.height/2, max: size.height - obs.size.height/2))
            obs.moveSprite(location: CGPoint(x: size.width + obs.size.width/2, y: obs.position.y), duration: 2.2)
        } else if direction == "Left" {
            obs.initWall()
            obs.position =  CGPoint(x: size.width + obs.size.width/2, y: random(min: obs.size.height/2, max: size.height - obs.size.height/2))
            obs.moveSprite(location: CGPoint(x: -obs.size.width/2, y: obs.position.y), duration: 2.2)
        }
        worldNode.addChild(obs)
        
    }
    
    // Creates an "Explosion" of wednesdayFrogs from the center bottom of the screen
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
    
    // Creates a 3 warning areas before creating laserBeams in those areas accompanied with sounds. Order is random.
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
    
    // Create illuminati triangle that randomly moves around the screen
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
    
    // creates 3 hitMarkers in random locations accompanied by sound
    func obstacle5() {
        worldNode.run(SKAction.sequence([
            SKAction.run {
                self.playSoundFile(soundFile: "triple", duration: 6.0)
            },
            SKAction.wait(forDuration: 2.0),
            SKAction.repeat(SKAction.sequence([
                SKAction.run {
                    let randomPoint = createRandomPoint()
                    self.createHitMarker(position: randomPoint)
                },
                SKAction.wait(forDuration: 0.3)]), count: 3)
            ]))
    }
    
    func createHitMarker(position: CGPoint) {
        let hitMarker = HitMarker(imageNamed: "hitmarker")
        hitMarker.initHitMarker(position: position)
        worldNode.addChild(hitMarker)
        
        playSoundFile(soundFile: "hitmarker", duration: 1.0)
        
        let actionWait = SKAction.wait(forDuration: 1.0)
        let actionWaitDone = SKAction.removeFromParent()
        hitMarker.run(SKAction.sequence([actionWait, actionWaitDone]))
    }
    
    // Creates an air horn which enters top, bottom, left, right or a corner of the screen and creates a soundwave which kills the player in that area accompanied by an airhorn blast sound
    func obstacle6() {
        let airHorn = AirHorn(imageNamed: "airhorn")
        airHorn.initHorn()
        worldNode.addChild(airHorn)
        let startPosition = ["Left", "Right", "Top", "Bottom", "TopLeft", "TopRight", "BottomLeft", "BottomRight"].randomItem()

        switch startPosition {
        case "Left"?:
            airHorn.xScale = airHorn.xScale * -1
            airHorn.position = CGPoint(x: 0 - airHorn.size.width/2, y: size.height/2)
            let positionToMoveTo = CGPoint(x: airHorn.size.width/8, y: size.height/2)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        case "Right"?:
            airHorn.position = CGPoint(x: size.width + airHorn.size.width/2, y: size.height/2)
            let positionToMoveTo = CGPoint(x: size.width - airHorn.size.width/8, y: size.height/2)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        case "Top"?:
            airHorn.zRotation = 90 * DegreesToRadians
            airHorn.position = CGPoint(x: size.width/2, y: size.height + airHorn.size.height)
            let positionToMoveTo = CGPoint(x: size.width/2, y: size.height - airHorn.size.height/8)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        case "Bottom"?:
            airHorn.xScale = airHorn.xScale * -1
            airHorn.zRotation = 90 * DegreesToRadians
            airHorn.position = CGPoint(x: size.width/2, y: 0 - airHorn.size.height)
            let positionToMoveTo = CGPoint(x: size.width/2, y: airHorn.size.height/8)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        case "TopLeft"?:
            airHorn.xScale = airHorn.xScale * -1
            airHorn.zRotation = 315 * DegreesToRadians
            airHorn.position = CGPoint(x: 0 - airHorn.size.width, y: size.height + airHorn.size.height)
            let positionToMoveTo = CGPoint(x: 0 + airHorn.size.width/8, y: size.height - airHorn.size.height/8)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        case "TopRight"?:
            airHorn.zRotation = 45 * DegreesToRadians
            airHorn.position = CGPoint(x: size.width + airHorn.size.width, y: size.height + airHorn.size.height)
            let positionToMoveTo = CGPoint(x: size.width - airHorn.size.width/8, y: size.height - airHorn.size.height/8)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        case "BottomLeft"?:
            airHorn.xScale = airHorn.xScale * -1
            airHorn.zRotation = 45 * DegreesToRadians
            airHorn.position = CGPoint(x: 0 - airHorn.size.width, y: 0 - airHorn.size.height)
            let positionToMoveTo = CGPoint(x: 0 + airHorn.size.width/8, y: 0 + airHorn.size.height/8)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        case "BottomRight"?:
            airHorn.zRotation = 315 * DegreesToRadians
            airHorn.position = CGPoint(x: size.width + airHorn.size.width, y: 0 - airHorn.size.height)
            let positionToMoveTo = CGPoint(x: size.width - airHorn.size.width/8, y: 0 + airHorn.size.height/8)
            airHorn.run(SKAction.move(to: positionToMoveTo, duration: 2.0))
        default:
            print("AirHorn startPosition Default error")
        }
        airHorn.createHornPhysicsBody()
        let actionPlayAirhornSound = SKAction.run {
            self.playSoundFile(soundFile: "Air Horn Sound Effect", duration: 3.0)
        }
        let actionRunSoundBlast = SKAction.run {
            airHorn.texture = SKTexture(imageNamed: "airhornBlast")
            airHorn.updateHornPhysicsBodySoundWave()
        }
        airHorn.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), actionPlayAirhornSound, actionRunSoundBlast]))
        airHorn.run(SKAction.sequence([SKAction.wait(forDuration: 4.5), SKAction.removeFromParent()]))
        
    }
    
    // Creates a warning area on one half of the screen, the drops a uganda knuckles from the top of that half of the screen accompanied by sound
    func obstacle7() {
        let timeBeforeKnuckles = 2.0
        let randomX = size.width/2 + size.width/4 * CGFloat.randomSign
        
        createWarningArea(width: size.width/2, height: size.height, position: CGPoint(x: randomX, y: size.height/2), duration: timeBeforeKnuckles)
        
        let knuckles = Knuckles(imageNamed: "knuckles")
        knuckles.initKnuckles()
        knuckles.position = CGPoint(x: randomX, y: size.height + knuckles.size.height/2)
        worldNode.addChild(knuckles)
        knuckles.makeKnucklesRotate()
        
        let actionWait = SKAction.wait(forDuration: timeBeforeKnuckles)
        let locationToMoveTo = knuckles.position - CGPoint(x: 0, y: size.height + knuckles.size.height)
        
        worldNode.run(SKAction.sequence([
            actionWait,
            SKAction.run {
                self.playSoundFile(soundFile: "doyouknowdawae", duration: 1.5)
                knuckles.moveSprite(location: locationToMoveTo, duration: 1.5)
            }
            ]))
    }
    
    // Chase player, run soundclip
    func obstacle8(){
        let chase = Chase(imageNamed: "chase")
        chase.initChase()
        chase.position = CGPoint(x: -chase.size.width, y: size.height/2)
        worldNode.addChild(chase)
        
        let actionRunSound = SKAction.run {
            self.playSoundFile(soundFile: "run", duration: 9.0)
        }
        let actionWait = SKAction.wait(forDuration: 1.5)
        let actionMoveChase = SKAction.run {
            self.chaseArray.append(chase)
        }
        let actionMoveDone = SKAction.sequence([
            SKAction.wait(forDuration: 7.5),
            SKAction.run {
                self.chaseArray.removeFirst()
                chase.removeFromParent()
            }
            ])

        
        worldNode.run(SKAction.sequence([
            actionRunSound,
            actionWait,
            actionMoveChase,
            actionMoveDone
            ]))
        
    }

    func processChaseMovement() {
        for chase in chaseArray {
            if let player = worldNode.childNode(withName: GameData.shared.kPlayerName) as? SKSpriteNode {
                if player.position.x >= chase.position.x {
                    chase.physicsBody?.velocity.dx = 150/414 * size.width
                } else if player.position.x < chase.position.x {
                    chase.physicsBody?.velocity.dx = -(150/414 * size.width)
                }
                
                if player.position.y >= chase.position.y {
                    chase.physicsBody?.velocity.dy = 150/414 * size.width
                } else if player.position.y < chase.position.y {
                    chase.physicsBody?.velocity.dy = -(150/414 * size.width)
                }
            }
        }
    }
    
    // Long cat goes up super long time, comes down other side
    func obstacle9(){
        let longcat = LongCat(imageNamed: "longcat")
        longcat.initLongCat()
        longcat.position = CGPoint(x: size.width * (5/6), y: -longcat.size.height/2)
        worldNode.addChild(longcat)
        
        let longcat2 = LongCat(imageNamed: "longcat")
        longcat2.initLongCat()
        longcat2.zRotation = 180 * DegreesToRadians
        longcat2.position = CGPoint(x: size.width * (1/6), y: size.height + longcat.size.height/2)
        worldNode.addChild(longcat2)
        
        let actionLongCatMoveUp = SKAction.run {
            longcat.moveLongCatUp()
        }
        let actionWait = SKAction.wait(forDuration: 5.0)
        let actionLongCatMoveDown = SKAction.run {
            longcat2.moveLongCatDown()
        }
        
        worldNode.run(SKAction.sequence([
            actionLongCatMoveUp,
            actionWait,
            actionLongCatMoveDown
            ]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let player = worldNode.childNode(withName: GameData.shared.kPlayerName) as? Player {
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
        if !gameOver {
            gameOverSceneLoad(view: view!)
        }
        gameOver = true
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
            if !gameOver {
                gameOverSceneLoad(view: view!)
            }
            gameOver = true
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
        
        if startGame && firstTimeStart {
            firstTimeStart = false
            startLabel.removeFromParent()
            highScoreTable.removeFromParent()
            highScoreBackground.removeFromParent()
            createHud()
            randomObstacle(obsticle: Int(arc4random_uniform(9) + 1))
        }
        
        if startGame {
            counter = counter + 1
            GameData.shared.playerScore = GameData.shared.playerScore + 1
            updateHud()
        }
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        if startGame && CGFloat(dt) >= random(min: 4, max: 5) {
            self.lastUpdateTime = currentTime
            //randomObstacle(obsticle: Int(arc4random_uniform(9) + 1))
            randomObstacle(obsticle: 9)
        }
        
        if !chaseArray.isEmpty {
            processChaseMovement()
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

