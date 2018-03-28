//
//  Helpers.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-24.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//


import SpriteKit
import Foundation
import AVFoundation

func gameOverSceneLoad(view: UIView) {
    let scene = GameOverScene(size: view.bounds.size)
    let skView = view as! SKView
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .resizeFill
    skView.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
}

func gameSceneLoad(view: UIView) {
    let scene = GameScene(size: view.bounds.size)
    let skView = view as! SKView
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .resizeFill
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.presentScene(scene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func distanceBetweenTwoPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
    return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
}

public extension CGFloat {
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
}

public extension SKSpriteNode {
    
    public func moveSprite(location: CGPoint, duration: CGFloat) {
        let actionMove = SKAction.move(to: location, duration: TimeInterval(duration))
        let actionMoveDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
}

