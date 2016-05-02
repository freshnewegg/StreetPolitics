//
//  Fighting Scene.swift
//  PartisanLines
//
//  Created by Edgar Wang on 2016-04-14.
//  Copyright (c) 2016 Edgar Wang. All rights reserved.
/* This file is the brain of the scene */

import UIKit
import SpriteKit

class Fighting_Scene: SKScene, SKPhysicsContactDelegate {
    var score = 0 ;
    var countActions = 0;
    var screenWidth = UIScreen.mainScreen().bounds.width
    var halfOfScreenWidth = UIScreen.mainScreen().bounds.width/2
    
    //character animations
    var myPlayer : Player? = nil
    var characterAnimation = [SKTexture]()
    
    //The class that handles the actions
    var brain = FightingBrain()
    
    //time for frame by frame actions
    private var lastUpdateTime: CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        initShooterScene()
        setUpRecognizers()
        setUpGround()
        
        physicsWorld.contactDelegate = self
        
        //threading example
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while (true){
                if (self.brain.isEmpty() == false){
                    self.displayAction(self.brain.getNext()!)
                }
            }
        })*/
    }
    
    //set up the ground in the game
    func setUpGround(){
        let groundTexture = SKTexture(imageNamed: "purplebrick")
        var numBrick = screenWidth / groundTexture.size().width;
        for i in 0 ... Int(numBrick){
            let ground = SKSpriteNode(texture:groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: groundTexture.size())
            ground.physicsBody?.dynamic = false
            addChild(ground)
        }
    }
    
    func initShooterScene(){
        //setup brain
        brain.myScene = self
        
        //initialize the character animations
        let characterAtlas = SKTextureAtlas(named: "sprite")
        for index in 1...characterAtlas.textureNames.count{
            let imgName = String(format: "sprite%01d",index-1)
            characterAnimation += [characterAtlas.textureNamed(imgName)]
        }
        
        //set up character nodes
        myPlayer = brain.createPlayer()
        addChild(myPlayer!)

        //create new sprite node
        addChild(brain.createPlayer()!)

        //setup the healthbar
        var progressValue = 200
        var HealthBar = SKSpriteNode(color:SKColor.redColor(), size: CGSize(width: progressValue, height: 30))
        HealthBar.name = "healthbar"
        HealthBar.position = CGPointMake(self.frame.size.width / 3, self.frame.size.height / 1.05)
        HealthBar.anchorPoint = CGPointMake(0.0, 0.5)
        HealthBar.zPosition = 4
        self.addChild(HealthBar)
        
    }
    
    //set up the action recognition
    func setUpRecognizers(){
        //note the colon means there an argument
        let tapGesture = UITapGestureRecognizer(target: self, action: "Tap:")  //Tap function will call when user tap on button
        let longGesture = UILongPressGestureRecognizer(target: self, action: "Tap:") //Long function will call when user long press on button.
        tapGesture.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapGesture)
        self.view!.addGestureRecognizer(longGesture)
    }

    //send the action to the brain
    func Tap(recognizer: UIGestureRecognizer){
        let touchType = recognizer
        if (myPlayer != nil){
            //determine location of touch
            let location = touchType.locationInView(self.view)
            //determines what type of action is pressed and it sends it to be applied
            if (touchType.isKindOfClass(UITapGestureRecognizer)){
                //ACTION: ATTACK & COUNTER
                if (location.x > halfOfScreenWidth){
                    brain.addAction(Player.actionState.ATTACK)
                } else if (location.x < halfOfScreenWidth){
                    brain.addAction(Player.actionState.BLOCK)
                }
                //ACTION: MOVE RIGHT & LEFT
            } else if touchType.isKindOfClass(UILongPressGestureRecognizer) && touchType.state == .Began{
                if (location.x > halfOfScreenWidth){
                    brain.addAction(Player.actionState.MOVERIGHT)
                } else if (location.x < halfOfScreenWidth){
                    brain.addAction(Player.actionState.MOVELEFT)
                }
            }
        }
    }
    
    //move the character
    func displayAction(action : Player.actionState){
        if (myPlayer != nil){
            switch action{
            case .MOVELEFT:
                myPlayer?.position.x -= 50
            case .MOVERIGHT:
                myPlayer?.position.x += 50
            case .ATTACK:
                let animation = SKAction.animateWithTextures(characterAnimation, timePerFrame: 0.25)
                myPlayer?.runAction(animation)
            case .BLOCK:
                //to be added
                print("block")
            case .NEUTRAL:
                print("neutral")
            }
        }
    }
    
    // Called exactly once per frame as long as the scene is presented in a view and isn't paused
    override func update(currentTime: NSTimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1.0 / 60.0
            lastUpdateTime = currentTime
        }
        brain.updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    }
    
    
    
    //manages contact between objects
    func didBeginContact(contact: SKPhysicsContact!) {
        var firstBody: SKPhysicsBody!
        var secondBody: SKPhysicsBody!
        //print("contact")
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask == FightingBrain.CollisionTypes.PLAYER2.rawValue && secondBody.categoryBitMask == FightingBrain.CollisionTypes.HITBOX.rawValue){
            print("damaged p2")
        }
    }
}
