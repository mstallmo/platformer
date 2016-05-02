//
//  EndScene.swift
//  platformer
//
//  Created by Mason Stallmo on 5/1/16.
//  Copyright © 2016 Mason Stallmo. All rights reserved.
//

import SpriteKit

class EndScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        
        let gameOver = SKLabelNode(fontNamed: "Courier")
        gameOver.text = "Game Over"
        gameOver.fontSize = 45
        gameOver.fontColor = SKColor.redColor()
        gameOver.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        let touch = SKLabelNode(fontNamed: "Courier")
        touch.text = "Tap to play again"
        touch.fontSize = 35
        touch.fontColor = SKColor.redColor()
        touch.position = CGPoint(x:CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame) - 50))
        
        self.addChild(gameOver)
        self.addChild(touch)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let gameScene = GameScene(fileNamed: "GameScene") {
            let dissolve = SKTransition.fadeWithDuration(0.5)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.view?.presentScene(gameScene, transition: dissolve)
        }
    }
    
}
