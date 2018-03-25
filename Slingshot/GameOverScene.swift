//
//  GameOver.swift
//  Slingshot
//
//  Created by Robert Desjardins on 2018-03-24.
//  Copyright © 2018 Robert Desjardins. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

class GameOverScene: SKScene {
    
    var restartButton: SKSpriteNode! = nil
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        createRestartButton()
    }
    
    func createRestartButton() {
        let buttonWidth = size.width - 80
        let buttonHeight = buttonWidth * 0.2974683544
        restartButton = SKSpriteNode(imageNamed: "button_restart")
        restartButton.zPosition = 2
        restartButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        restartButton.position = CGPoint(x: size.width/2, y: restartButton.size.height + 10)
        addChild(restartButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if restartButton.contains(touchLocation) {
            gameSceneLoad(view: view!)
        }
    }
}
