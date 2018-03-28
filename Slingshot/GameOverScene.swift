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
    var losingSound: AVAudioPlayer! = nil
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        createRestartButton()
        playLosingSound()
        GameData.shared.creditsEarned = GameData.shared.creditsEarned + Int(round(Double(GameData.shared.playerScore/35)))
        createScoreLabel()
        GameData.shared.playerHighScore.append(GameData.shared.playerScore)
        formatHighScores(arrayOfScores: GameData.shared.playerHighScore)
        UserDefaults.standard.setUserHighScores(array: GameData.shared.playerHighScore)
        let newCreditBalance = GameData.shared.totalCredits + GameData.shared.creditsEarned
        UserDefaults.standard.setUserCredits(credits: newCreditBalance)
        resetGameData()
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
    
    func createScoreLabel() {
        let scoreLabel = SKLabelNode(fontNamed: "Avenir")
        scoreLabel.fontSize = 35
        scoreLabel.fontColor = SKColor.white
        scoreLabel.text = "Score: \(GameData.shared.playerScore)"
        scoreLabel.position = restartButton.position - CGPoint(x: 0, y: (restartButton.size.height/2 + 35))
        
        self.addChild(scoreLabel)
    }
    
    func playLosingSound() {
        let randomSound = Int(arc4random_uniform(3))
        var path:String = ""
        
        switch randomSound {
        case 0:
            path = Bundle.main.path(forResource: "pranked.wav", ofType:nil)!
        case 1:
            path = Bundle.main.path(forResource: "losinghorn.wav", ofType:nil)!
        case 2:
            path = Bundle.main.path(forResource: "ohshit.wav", ofType:nil)!
        default:
            print("playLosingSound out of range")
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            losingSound = try AVAudioPlayer(contentsOf: url)
            losingSound?.play()
        } catch {
            print("Couldn't play losing sound")
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        if restartButton.contains(touchLocation) {
            gameSceneLoad(view: view!)
        }
    }
}
