//
//  AirHorn.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-28.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class AirHorn: SKSpriteNode {
    func initHorn() {
        self.name = GameData.shared.kObstacleName
        self.size = CGSize(width: GameData.shared.deviceHeight * (1/2), height: GameData.shared.deviceHeight * (1/2))
        self.zPosition = 2
    }
    
    func createHornPhysicsBody(){
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
    func updateHornPhysicsBody(){
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    
//    func createSoundBlast() -> SKSpriteNode {
//        let soundWave = SKSpriteNode(imageNamed: "soundWave")
//        soundWave.name = GameData.shared.kObstacleName
//        let soundWaveHeight = GameData.shared.deviceHeight * (1/3)
//        let soundWaveWidth = soundWaveHeight * 0.505124451
//        soundWave.size = CGSize(width: soundWaveHeight, height: soundWaveWidth)
//
//        soundWave.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
//        soundWave.physicsBody?.isDynamic = false
//        soundWave.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
//        soundWave.physicsBody?.contactTestBitMask = PhysicsCategory.Player
//        soundWave.physicsBody?.collisionBitMask = PhysicsCategory.None
//
//        return soundWave
//    }
    
//    func angleAndPositionSoundBlast(soundWave: SKSpriteNode) {
//        let airHornDegreesRotation = self.zRotation * RadiansToDegrees
//        var actualXDif: CGFloat! = nil
//        var actualYDif: CGFloat! = nil
//
//        if self.xScale == -1 {
//            soundWave.zRotation = self.zRotation
//            if airHornDegreesRotation >= 0 && airHornDegreesRotation <= 90 {
//                actualXDif = self.size.width/2 - ((self.size.width/2) * (airHornDegreesRotation / 90))
//                actualYDif = self.size.width/2 - ((self.size.width/2) * ((90 - airHornDegreesRotation) / 90))
//            } else {
//                actualXDif = self.size.width/2 - ((self.size.width/2) * (airHornDegreesRotation / 360))
//                actualYDif = self.size.width/2 - ((self.size.width/2) * ((90 - airHornDegreesRotation) / 360))
//            }
//            soundWave.position = self.position + CGPoint(x: actualXDif, y: actualYDif)
//        } else {
//            soundWave.xScale = soundWave.xScale * -1
//            soundWave.zRotation = self.zRotation
//        }
//    }
    
}
