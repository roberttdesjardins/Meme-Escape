//
//  illuminati.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-28.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class Illuminati: SKSpriteNode {
    func initTriangle(position: CGPoint) {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: 150, height: 150)
        self.zPosition = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func rotateTriangle() {
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2 * CGFloat.randomSign, duration: TimeInterval(random(min: 0.5, max: 3.0)))
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        self.run(repeatRotation)
    }
    
    
    func moveForDuration(time: TimeInterval){
        let randomPoint = createRandomPoint()
        
        let distanceToRandomPoint = distanceBetweenTwoPoints(point1: self.position, point2: randomPoint)
        let actualDuration = distanceToRandomPoint/GameData.shared.deviceHeight
        
        if actualDuration <= CGFloat(time) {
            let actionMove = SKAction.move(to: randomPoint, duration: TimeInterval(actualDuration))
            let actionRepeat = SKAction.run {
                self.moveForDuration(time: time - TimeInterval(actualDuration))
            }
            run(SKAction.sequence([actionMove, actionRepeat]))
        } else {
            removeFromParent()
        }
    }
}
