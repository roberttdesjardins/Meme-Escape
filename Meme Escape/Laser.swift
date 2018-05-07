//
//  Laser.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-26.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class Laser: SKSpriteNode {
    func initLaser(position: CGPoint) {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: 50, height: GameData.shared.deviceHeight)
        self.zPosition = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func runGif() {
        var gifLaser: [SKTexture] = []
        for i in 1...12 {
            gifLaser.append(SKTexture(imageNamed: "teslaColor\(i)"))
        }
        self.run(SKAction.repeatForever(SKAction.animate(with: gifLaser, timePerFrame: 0.03)))
        
        self.run(SKAction.wait(forDuration: 3), completion: {
            self.removeFromParent()
        })
    }
}
