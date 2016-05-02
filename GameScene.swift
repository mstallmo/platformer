//
//  GameScene.swift
//  platformer
//
//  Created by Mason Stallmo on 5/1/16.
//  Copyright (c) 2016 Mason Stallmo. All rights reserved.
//

import SpriteKit
import CoreMotion

struct Physics {
    static let Player : UInt32 = 0x1 << 1
    static let Water : UInt32 = 0x1 << 2
    static let Ground : UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var water = SKSpriteNode()
    var player = SKSpriteNode()
    var platforms = SKNode()
    
    var scoreLabel = SKLabelNode?()
    var jumpLabel = SKLabelNode?()
    var start = SKLabelNode?()
    var instructions = SKLabelNode?()
    
    var move = SKAction()
    
    var motionManager = CMMotionManager()
    
    var destX:CGFloat = 0.0
    
    var count = 5
    
    var score = 0
    
    var gameStart = false
    
    override func didMoveToView(view: SKView) {
        
        //self.backgroundColor = SKColor.blackColor()
        let background = SKSpriteNode(imageNamed: "background2")
        background.zPosition = 1
        background.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(background)
        
        
        scene?.scaleMode = SKSceneScaleMode.AspectFill
        
        physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        motionManager.startAccelerometerUpdates()
        
        self.scoreLabel = SKLabelNode(fontNamed: "Courier")
        self.scoreLabel!.text = "Score: 0"
        self.scoreLabel!.fontSize = 36
        self.scoreLabel!.horizontalAlignmentMode = .Left
        self.scoreLabel!.position = CGPoint(x: CGRectGetMinX(self.frame) + 40, y: CGRectGetMaxY(self.frame) - 40)
        self.scoreLabel!.zPosition = 3
        
        self.addChild(self.scoreLabel!)
        
        self.jumpLabel = SKLabelNode(fontNamed: "Courier")
        self.jumpLabel!.text = "Jump Count: 5"
        self.jumpLabel!.fontSize = 36
        self.jumpLabel!.horizontalAlignmentMode = .Left
        self.jumpLabel!.position = CGPoint(x: CGRectGetMinX(self.frame) + 250, y: CGRectGetMaxY(self.frame) - 40)
        self.jumpLabel!.zPosition = 3
        
        self.addChild(self.jumpLabel!)
        
        water = SKSpriteNode(imageNamed: "Water")
        water.name = "water"
        water.setScale(0.5)
        water.position = CGPoint(x: self.frame.width / 2, y: 0 + water.frame.height / 2)
        water.zPosition = 3
        
        water.physicsBody = SKPhysicsBody(rectangleOfSize: water.size)
        water.physicsBody?.categoryBitMask = Physics.Water
        water.physicsBody?.collisionBitMask = Physics.Player | Physics.Ground
        water.physicsBody?.contactTestBitMask = Physics.Player | Physics.Ground
        water.physicsBody?.affectedByGravity = false
        water.physicsBody?.dynamic = false
        water.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(water)
        
        player = SKSpriteNode(imageNamed: "Player")
        player.name = "player"
        player.size = CGSize(width:  60, height: 70)
        player.setScale(0.5)
        player.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 75)
        player.zPosition = 3
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.categoryBitMask = Physics.Player
        player.physicsBody?.collisionBitMask = Physics.Ground | Physics.Water
        player.physicsBody?.contactTestBitMask = Physics.Ground | Physics.Water
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = true
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(player)
        
        self.start = SKLabelNode(fontNamed: "Courier")
        self.start!.text = "Tap to begin"
        self.start!.fontSize = 45
        self.start!.fontColor = SKColor.redColor()
        self.start!.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.start!.zPosition = 3
        
        self.addChild(start!)
        
        self.instructions = SKLabelNode(fontNamed: "Courier")
        self.instructions!.text = "Tilt the phone to control movement"
        self.instructions!.fontSize = 45
        self.instructions!.fontColor = SKColor.redColor()
        self.instructions!.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 75)
        self.instructions!.zPosition = 3
        
        self.addChild(instructions!)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if gameStart == false {
            
            gameStart = true
            
            player.physicsBody?.affectedByGravity = true
            start?.runAction(SKAction.removeFromParent())
            instructions?.runAction(SKAction.removeFromParent())
            
            let spawn = SKAction.runBlock({
                () in
            
                self.createPlatform()
            })
        
            let delay = SKAction.waitForDuration(1.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForver = SKAction.repeatActionForever(SpawnDelay)
            self.runAction(spawnDelayForver)
        
            let distance = CGVectorMake(0, -self.frame.height)
            move = SKAction.moveBy(distance, duration: NSTimeInterval(10))
            
            if count > 0 {
                player.physicsBody?.velocity = CGVectorMake(0, 0)
                player.physicsBody?.applyImpulse(CGVectorMake(0, 30))
                count -= 1
                self.jumpLabel!.text = "Jump Count: \(count)"
            }
                
        } else {
        
            if count > 0 {
                player.physicsBody?.velocity = CGVectorMake(0, 0)
                player.physicsBody?.applyImpulse(CGVectorMake(0, 30))
                count -= 1
                self.jumpLabel!.text = "Jump Count: \(count)"
            }
        }
        
    }
    
    func createPlatform(){
        
        platforms = SKNode()
        
        let smallPlatform = SKSpriteNode(imageNamed: "Small-Platform")
        
        
        smallPlatform.position = CGPoint(x: 200 , y: self.frame.height)
        smallPlatform.name = "smallPlatform"
        smallPlatform.setScale(0.5)
        
        smallPlatform.physicsBody = SKPhysicsBody(rectangleOfSize: smallPlatform.size)
        smallPlatform.physicsBody?.categoryBitMask = Physics.Ground
        smallPlatform.physicsBody?.collisionBitMask = Physics.Player | Physics.Water
        smallPlatform.physicsBody?.contactTestBitMask = Physics.Player | Physics.Water
        smallPlatform.physicsBody?.affectedByGravity = false
        smallPlatform.physicsBody?.dynamic = false
        smallPlatform.physicsBody?.usesPreciseCollisionDetection = true
        
        platforms.addChild(smallPlatform)
        
        platforms.zPosition = 2
        
        let randomPos = random(0, second: frame.width)
        
        platforms.position.x = randomPos - platforms.frame.width
        
        platforms.runAction(move)
        self.addChild(platforms)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let aNode = contact.bodyA.node
        let bNode = contact.bodyB.node
        
        if aNode!.name == "player" && bNode!.name == "smallPlatform"  {
            print ("contact")
            bNode!.runAction(SKAction.removeFromParent())
            count = 5
            score += 1
            self.scoreLabel!.text = "Score: \(score)"
        } else if aNode!.name == "smallPlatform"  && bNode!.name == "player"{
            print("contact")
            aNode!.runAction(SKAction.removeFromParent())
            count = 5
            score += 1
            self.scoreLabel!.text = "Score: \(score)"
        } else if aNode!.name == "water" && bNode!.name == "smallPlatform" {
            print("platform contacted water")
            bNode!.runAction(SKAction.removeFromParent())
        } else if aNode!.name == "smallPlatform" && bNode!.name == "water" {
            print("platform contacted water")
            aNode!.runAction(SKAction.removeFromParent())
        } else if aNode!.name == "player" && bNode!.name == "water" {
            aNode!.runAction(SKAction.removeFromParent())
            let endScene = EndScene(fileNamed: "EndScene")
            let dissolve = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(endScene!, transition: dissolve)
            
        } else if aNode!.name == "water" && bNode!.name == "player"{
            bNode!.runAction(SKAction.removeFromParent())
            let endScene = EndScene(fileNamed: "EndScene")
            let dissolve = SKTransition.fadeWithDuration(0.5)
            self.view?.presentScene(endScene!, transition: dissolve)
            
        }
    }
    
    func random(first: CGFloat, second: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(first - second) + min(first, second)
    }
    
    func userMotion(currentTime: CFTimeInterval){
        let player = childNodeWithName("player") as! SKSpriteNode
        
        if let data = motionManager.accelerometerData {
            
            if (fabs(data.acceleration.x) > 0.1) {
                player.physicsBody!.applyForce(CGVectorMake(40.0 * CGFloat(data.acceleration.x), 0))
            }
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
       userMotion(currentTime)
        
    }
}
