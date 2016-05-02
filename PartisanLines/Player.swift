//
//  CharacterNode.swift
//  PartisanLines
//
//  Created by Edgar Wang on 2016-04-27.
//  Copyright (c) 2016 Edgar Wang. All rights reserved.
//

import SpriteKit
import UIKit

class Player: SKSpriteNode{
    
    //Sets up the character node on the view
    let spriteWidth:CGFloat = 88.236
    let spriteHeight:CGFloat = 81.633
    
    //set up the character health and action state
    var health = 100
    var state: actionState = actionState.NEUTRAL
    var hitbox: SKSpriteNode? = nil
    
    enum actionState{
        case NEUTRAL
        case ATTACK
        case BLOCK
        case MOVELEFT
        case MOVERIGHT
    }
    
    init(spriteName : String?, xStartPosition: CGFloat){
        let texture = SKTexture(imageNamed: "sprite0")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        name = spriteName
        size.width = spriteWidth
        size.height = spriteHeight
        position = CGPoint(x: xStartPosition, y: 200)
        let sprite = SKSpriteNode(imageNamed: "sprite0")

        physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.dynamic = true
        if (spriteName == "trump"){
            physicsBody?.categoryBitMask = FightingBrain.CollisionTypes.PLAYER1.rawValue
        }
        else{
            physicsBody?.categoryBitMask = FightingBrain.CollisionTypes.PLAYER2.rawValue
        }
        physicsBody?.collisionBitMask = FightingBrain.CollisionTypes.HITBOX.rawValue
        physicsBody?.contactTestBitMask = FightingBrain.CollisionTypes.HITBOX.rawValue
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    //enter the attack state
    //generate some sort of hitbox, define the collidable types
    func attack() -> SKNode?{
        if (state == actionState.NEUTRAL){
            state = actionState.ATTACK
            
            //generate hitboxes
            hitbox = SKSpriteNode(color:SKColor.redColor(), size: CGSize(width: 30, height: 30))
            hitbox?.position = CGPoint (x: self.position.x + spriteWidth, y: self.position.y)
            hitbox?.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: spriteWidth, height: spriteHeight))
            hitbox?.color = SKColor.redColor()
            hitbox?.physicsBody?.dynamic = true
            hitbox?.physicsBody?.affectedByGravity = false
            
            //setting contact with player 2
            hitbox?.physicsBody?.categoryBitMask = FightingBrain.CollisionTypes.HITBOX.rawValue
            hitbox?.physicsBody?.collisionBitMask = FightingBrain.CollisionTypes.PLAYER2.rawValue
            hitbox?.physicsBody?.contactTestBitMask = FightingBrain.CollisionTypes.PLAYER2.rawValue
            
            return hitbox
        }
        return nil
    }
    
    //enter the neutral state
    func neutral(){
        state = actionState.NEUTRAL
        hitbox?.removeFromParent()
    }
    
    //enter the block state
    func block(){
        state = actionState.BLOCK
    }
    
    //move left
    func moveLeft(){
        //state = actionState.MOVELEFT
    }
    
    //move right
    func moveRight(){
        //state = actionState.MOVERIGHT
    }
}