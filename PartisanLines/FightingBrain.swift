//
//  FightingBrain.swift
//  PartisanLines
//
//  Created by Edgar Wang on 2016-04-27.
//  Copyright (c) 2016 Edgar Wang. All rights reserved.
//

import Foundation
import SpriteKit

class FightingBrain{
    //actions for the players
    enum action{
        case MOVERIGHT
        case MOVELEFT
        case ATTACK
        case COUNTER
    }
    
    var myScene : Fighting_Scene? = nil
    
    var queue = Queue<action>()
    
    //send action to server
    func addAction(currentAction: action){
        queue.enQueue(currentAction)
        self.execute()
    }
    
    func execute(){
        myScene?.displayAction(self.queue.deQueue()!)
    }
    
    func isEmpty() -> Bool{
        return self.queue.isEmpty()
    }
}