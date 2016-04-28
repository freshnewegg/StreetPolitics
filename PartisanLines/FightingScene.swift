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
    var characterAnimation = [SKTexture]()
    
    //The class that handles the actions
    var brain = FightingBrain()
    
    override func didMoveToView(view: SKView) {
        initShooterScene()
        setUpRecognizers()
        setUpGround()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while (true){
                if (self.brain.isEmpty() == false){
                    self.displayAction(self.brain.getNext()!)
                }
            }
        })
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
        //initialize the character
        let sprite = SKSpriteNode(imageNamed: "sprite0")
        let characterAtlas = SKTextureAtlas(named: "sprite")
        for index in 1...characterAtlas.textureNames.count{
            let imgName = String(format: "sprite%01d",index-1)
            characterAnimation += [characterAtlas.textureNamed(imgName)]
        }
        let characterNode = self.childNodeWithName("characterNode")
        characterNode?.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width)
        characterNode?.physicsBody?.dynamic = true
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

        let characterNode = self.childNodeWithName("characterNode")
        if (characterNode != nil){
            //determine location of touch
            let location = touchType.locationInView(self.view)
            //determines what type of action is pressed and it sends it to be applied
            if (touchType.isKindOfClass(UITapGestureRecognizer)){
                //ACTION: ATTACK & COUNTER
                if (location.x > halfOfScreenWidth){
                    brain.addAction(FightingBrain.action.ATTACK)
                } else if (location.x < halfOfScreenWidth){
                    brain.addAction(FightingBrain.action.COUNTER)
                }
                //ACTION: MOVE RIGHT & LEFT
            } else if touchType.isKindOfClass(UILongPressGestureRecognizer) && touchType.state == .Began{
                if (location.x > halfOfScreenWidth){
                    brain.addAction(FightingBrain.action.MOVERIGHT)
                } else if (location.x < halfOfScreenWidth){
                    brain.addAction(FightingBrain.action.MOVELEFT)
                }
            }
        }
    }
    
    //move the character
    func displayAction(action : FightingBrain.action){
        let myCharacter = self.childNodeWithName("characterNode")
        if (myCharacter != nil){
            switch action{
            case .MOVELEFT:
                myCharacter?.position.x -= 20
            case .MOVERIGHT:
                myCharacter?.position.x += 20
            case .ATTACK:
                let animation = SKAction.animateWithTextures(characterAnimation, timePerFrame: 0.25)
                myCharacter?.runAction(animation)
            case .COUNTER:
                //to be added
                print("counter")
            }
        }
    }
}
