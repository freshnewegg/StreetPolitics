import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if let introlabel = childNodeWithName("Play"){
            let fadeOut = SKAction.fadeOutWithDuration(1)
            //when the button is pressed
            introlabel.runAction(fadeOut,{
                let doors = SKTransition.doorsCloseHorizontalWithDuration(1)
                // get the game scene
                let gameScene = Fighting_Scene(fileNamed: "FightingScene")
                //transition to the gamescene
                self.view?.presentScene(gameScene, transition: doors)
            })
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}
