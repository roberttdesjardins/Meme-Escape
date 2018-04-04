//
//  SWBlade.swift
//  SWBladeDemo
//
//  Created by Julio Montoya on 28/01/17.
//  Copyright (c) 2017 Julio Montoya. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


import UIKit
import SpriteKit

class SWBlade: SKNode {
    
    var emitterNode: SKEmitterNode {
        let emitterNode: SKEmitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "spark.png")
        emitterNode.particleBirthRate = 3000
        
        emitterNode.particleLifetime = 0.2
        emitterNode.particleLifetimeRange = 0
        
        emitterNode.particlePositionRange = CGVector.zero
        
        emitterNode.particleSpeed = 0.0
        emitterNode.particleSpeedRange = 0.0
        
        emitterNode.particleAlpha = 0.8
        emitterNode.particleAlphaRange = 0.2
        emitterNode.particleAlphaSpeed = -0.45
        
        emitterNode.particleScale = 0.5
        emitterNode.particleScaleRange = 0.001
        emitterNode.particleScaleSpeed = -1
        
        emitterNode.particleRotation = 0
        emitterNode.particleRotationRange = 0
        emitterNode.particleRotationSpeed = 0
        
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColorBlendFactorRange = 0
        emitterNode.particleColorBlendFactorSpeed = 0
        
        emitterNode.particleBlendMode = .add
        emitterNode.zPosition = 0
        
        return emitterNode
    }
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(position:CGPoint, target:SKNode, color:UIColor) {
        super.init()
        
        name = GameData.shared.kObstacleName
        self.position = position
        
        let tip:SKSpriteNode = SKSpriteNode(color: color, size: CGSize(width: 40, height: 40))
        tip.zRotation = 0.785398163
        tip.zPosition = 10
        addChild(tip)
        
        let emitter: SKEmitterNode = emitterNode
        emitter.particleColor = color
        emitter.targetNode = target
        tip.addChild(emitter)
        
        setScale(0.6)
    }
    
    // MARK: - Physics
    
    func enablePhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.isDynamic = false
    }
}
