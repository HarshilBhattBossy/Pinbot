//
//  ViewController.swift
//  PinBot
//
 
//  Copyright © 2018 Harshil Bhatt. All rights reserved.
//
// ADD THE SELCCTION REAVES  BACK AGAIN

import UIKit
import SceneKit
import ARKit
let GameClass = Game()
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate , SCNPhysicsContactDelegate {

    
   
    @IBOutlet weak var ReasonsDueToPause: UILabel!
    

    var AllowingToShoot = true
    
    var Tube = SCNScene(named: "NewssAugmentedThis.dae")!.rootNode
   
    
    @IBOutlet weak var DiscriptionOfTheGame: UILabel!
    @IBOutlet weak var VisualEffectLossScreen: UIVisualEffectView!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var TimeLimit: UILabel!
   
    @IBOutlet weak var CurrentScore: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    /// GameClass
    
    
    var PausedGame = false
    var ColorChanged = true // FOR TIME LIMIT LAEL
    var DiscriptionShowedOnce = false
    
    var ClickAdded = false
    var StartConfugure = false
    var WidthFromRender : CGFloat?
    var BreadthFromRender : CGFloat?
    var Postion : SCNVector3?
    var DidAddTube = false
    var GotWhatWeNeed = false /// THE SIZE IS 0.390 and 0.500
    var PlaneNode = SCNNode() /// NODE FOR PLANE
    var Tracking : SCNNode?
    var TrackingNodeAddedTube = false
    var FinishedTracking = false /// if it is true it means update time for arrow stops
    var IndexNumebr = 0
    /// FOR Face camera
    
    // VIEW FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneView.scene.physicsWorld.contactDelegate = self
        CurrentScore.text = " "
        // ADD WHAT LEVEL HAS HE CHOSEN
        //IndexNumebr = GameClass.GameModeChosen
        IndexNumebr = GameClass.GameModeChosen

        GameClass.RunBeforeGame()
        TimeLimit.text = "\(GameClass.Time)"
       
        // IF THE DISCRIPTION WAS  ONCE SHOWED OR NOT
        DiscriptionShowedOnce = false
        
        
     // SET REAVES HERE 
      let NodeGette = Reaves.GameModesAvaialble[GameClass.CurrentReavesPurchased]
       Tube = (SCNScene(named: NodeGette)?.rootNode)!
       
        
        ReStartGame()
        // REMOVE THE EXTERNAL VIEW FROM THE VIEW
        StartAgainScreen()
      
        
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
       
        
        PausedGame = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        VisualEffectLossScreen.transform = CGAffineTransform(translationX: 0, y: 2000)
      print("Load")
        PausedGame = false
    }
    var Tubess = SCNNode()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        sceneView.session.pause()
                PauseGame()
    }
    
    
    
    
    // TOCUHES NODE
    var GotIt = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //// Touch Controls
        /// Create Shooters
        
        guard GameClass.PausedGame == false else { return }
        
        guard GameClass.ConstantCheckIfTrueLost() == false  else {
            print("LOST ")
            ReasonsDueToPause.text = "! Time Up !"
            LossScreen()
            return
            
        }
       
    if Waits == true && AllowingToShoot {
            AllowingToShoot = false
        
            let CurrentFrame = self.sceneView.session.currentFrame
            let Transform = SCNMatrix4((CurrentFrame?.camera.transform)!)
            let Direction = SCNVector3(Transform.m31 * -1  , Transform.m32 * -1  , Transform.m33 * -1)
            // FORCE BY UNIQUE FEATURES OF WEAPON
            
            
            
            
            let GameClassWeaponChose = (GameClass.CurrentWeaponChosed)
            let Weapon = Float(WeaponUniqueFeatures.Name[GameClassWeaponChose].0)
            let DirectionForce = SCNVector3(Direction.x * Weapon , Direction.y * Weapon , Direction.z * Weapon )
            
            let GameWeaponNode = GameClass.CurrentWeapon.GetShooter(Direction: DirectionForce, simdTransform: (CurrentFrame?.camera.transform)!)
            GameWeaponNode.name = "Ball"
            //print(GameWeaponNode.name)
            /// Add to scene node
           // GameWeaponNode.physicsBody?.contactTestBitMask = 1
            
        
            GameWeaponNode.physicsBody?.categoryBitMask = 7
            GameWeaponNode.physicsBody?.contactTestBitMask = 7
        
            var ArrayssOfRockets = [SCNNode]()
            ArrayssOfRockets.append(GameWeaponNode)
            ArrayssOfRockets.append(GameWeaponNode)
            ArrayssOfRockets.append(GameWeaponNode)
        
        
            sceneView.scene.rootNode.addChildNode(GameWeaponNode)
       
            
//            GameClass.DecreaseBulletBy1()
//            Bullets.text = "\(GameClass.Bullets)⍋"

        }
        
        // Time Controller
        
        
        /// Track Nodes
        guard TrackingNodeAddedTube == false else {return}
//         guard Check()  else {return}
//        guard CheckForZ() else {return}
        // GameScene.scn
        // GameModeScene.scn
      // SsenneGame.scn
     
        //guard let InitialPosition = Postion else {return}
        Tubess = Tube
        // REMOVED THIS ALREADY 
//        guard CheckForZ() else {
//            DiscriptionOfTheGame.text = "Place The Node Far"
//
//            let Color = [UIColor.yellow , UIColor.blue , UIColor.red]
//            DiscriptionOfTheGame.textColor = Color[Int.random(in: 0..<Color.count)]
//
//            return}
        guard let track = Tracking?.position else {return}
        //.childNode(withName: "Tracker", recursively: false)!.childNode(withName: "plane", recursively: false)!
        Tube.position = track
        
        
        let Clouds = SCNScene(named: "Clouds.scn")!.rootNode
        let RainParticle = SCNParticleSystem(named: "Rain.scnp", inDirectory: nil)!
        Clouds.addParticleSystem(RainParticle)
        Tube.addChildNode(Clouds)
        Clouds.position = SCNVector3(0,13,0)
        
        let AddParticles = Tube.childNode(withName: "ThisTube", recursively: false)?.childNode(withName: "RunNode", recursively: false)
        let Parts  = SCNParticleSystem(named: "FireRocket.scnp", inDirectory: nil)
        AddParticles?.addParticleSystem(Parts!)
        
        
        
        
        
        sceneView.scene.rootNode.addChildNode(Tube)
        PlaneNode.removeFromParentNode()
        DidAddTube = true
        
        
        
        
        if GotIt == false {
        NodeForPosition = Tracking
            CurrentScore.text = "" /// SET Bullets
        GotIt = true
        }
        FinishedTracking = true
        Tracking?.removeFromParentNode()
        Tracking?.removeAllActions()
        TrackingNodeAddedTube = true
    }
    
    var NodeForPosition : SCNNode?
    var BoxesCreated = [SCNNode]()
    

    
    
    // MARK: - ARSCNViewDelegate
    
    

    
   
    
    
    
    




    var Times = 0
   
   
    var Waits = false
    var Num = 9
    var TimeToFire = 0.0
    // IMPORTATNT
    var Number = 0
    var NamesOfBoxesHit = [String]()
    // UPDATE ON TIME
    var ArrayOfNodesCategory = [SCNNode]() /// Nodes to add and remove when challange changesv
    var ArrayofStringsofCategory = [String]()
    var RemoveAfterSecods = 7
    var RemoveDiscritionAfter5Seconds = 6.0
    var WaitTime = 0.3
    // UPDATE AT TIME
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
     
        
        // HRE
        
        // HERE
        if WaitTime < time {
            WaitTime = time
        if !AllowingToShoot {
            AllowingToShoot = true
            WaitTime += 0.5
            
        }
        }
        
        
         if RemoveDiscritionAfter5Seconds < time {
             RemoveDiscritionAfter5Seconds = time + 2.0
        if DidAddTube {
            if DiscriptionShowedOnce == false {
              
                    let GameModeChosen = GameClass.GameModeChosen
                    DiscriptionOfTheGame.text = GameClass.GameMode[GameModeChosen].Discription
                
                DiscriptionShowedOnce = true
            } else {
                DiscriptionOfTheGame.text = ""
            }
        }
        }
        
        
        
        
        
        // IF GAME WAS PAUSED 
        guard GameClass.PausedGame == false else { return }
        // IF LOST GAME
        guard GameClass.ConstantCheckIfTrueLost() == false  else {
            ReasonsDueToPause.text = "! Time Up !"
            ContinueOutlet.isHidden = true
            LossScreen()
            return
            
        }
       
        guard PausedGame == false else {
           
            return
        }
            
        
        
        // BOXES CREATED
        if Num <= Int(time) {
            if BoxesCreated.count > 2 {
            BoxesCreated.remove(at: 0)
            Num = Int(time +  7)
            }
        }
        
        // Change Colors to Shoot at it
        if GameClass.GameMode[IndexNumebr].SecondsToChangeCurrentColor <= Int(time) {
            
            GameClass.GameMode[IndexNumebr].ChangeRandom()
            GameClass.GameMode[IndexNumebr].SecondsToChangeCurrentColor = GameClass.GameMode[IndexNumebr].SecondsToChangeColor + Int(time)
            
            
            for (Number , _ ) in ArrayofStringsofCategory.enumerated() {
               
                    if GameClass.GameMode[IndexNumebr].IfSoOrNotSo(ArrayofStringsofCategory[Number]  , PositveHit : GameClass.GameMode[IndexNumebr].PositiveHit) {
                        ArrayOfNodesCategory[Number].physicsBody?.categoryBitMask = 2
                    } else {
                        ArrayOfNodesCategory[Number].physicsBody?.categoryBitMask = 3
                    }
                    
                    
                    
                
                
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let RandomColors = [#colorLiteral(red: 1, green: 0.03523606524, blue: 0.2307029652, alpha: 1) , #colorLiteral(red: 0.650090843, green: 0.6224619444, blue: 0, alpha: 1) , #colorLiteral(red: 0.03357173882, green: 0.5736977945, blue: 0.650090843, alpha: 1) ,#colorLiteral(red: 0.3974209675, green: 0, blue: 0.650090843, alpha: 1) , #colorLiteral(red: 1, green: 0.9397628908, blue: 0.9895317718, alpha: 1) , #colorLiteral(red: 0.07529008494, green: 0.01886303161, blue: 0.4948219477, alpha: 1) ]
                let Random = Int.random(in: 0..<RandomColors.count)
                self.CurrentScore.textColor = RandomColors[Random]
                self.CurrentScore.text = GameClass.GameMode[self.IndexNumebr].PositiveHit
                
            }
            
           
        }
        }
        // REMOVE OF LAST ELEMENT IN ARRAy
        if RemoveAfterSecods <= Int(time) {
            RemoveAfterSecods = 10 + Int(time)
            if DidAddTube == true {
                if ArrayofStringsofCategory.count >= 8 {
                    
                ArrayofStringsofCategory.removeLast()
                ArrayofStringsofCategory.removeLast()
                }
            }
        }
        
       
        // CREATE BOX
        if Times <= Int(time) {
            if DidAddTube == true {
                
                
                
                
                
                
            /// Camera
            let CameraNodes = sceneView.session.currentFrame!.camera
            
            /// Camera Position
            let Position = SCNVector3((Tracking?.position.x)! , -1.5 , (Tracking?.position.z)!)
           
                /// BoxFromClass
                let Node =  GameClass.GameMode[IndexNumebr].GenerateBox(position: Position , Camera: CameraNodes)
                ArrayOfNodesCategory.append(Node.0)
                ArrayofStringsofCategory.append(Node.2)
                
                Node.0.physicsBody?.contactTestBitMask = Node.1
                Node.0.physicsBody?.categoryBitMask = Node.1
                
                
                
                Node.0.name = "\(Number)BOX"
                NamesOfBoxesHit.append("\(Node.0.name!)")
                Number += 1
                
               
              
                
                sceneView.scene.rootNode.addChildNode(Node.0)
                
                
                /// Check if Red
               
                
                
                
                
                /// Move Boxes
               // let Positions =  CameraNodes.transform /// Camera Positions
                let Random = Int.random(in: 0..<7)
                //            let SceneMoveTo = SCNVector3(Positions.columns.3.x, Positions.columns.3.y  , Positions.columns.3.z)

                if Random == 2 {
                  //  Node.0.runAction(.sequence([.wait(duration: 1.5) , SCNAction.move(to: SceneMoveTo, duration: 0.3)]))
                ///print("\(Node.name) Node Name")
                }
                
                Times = Int(time + 1.5) /// Time
                Waits = true
                
                
                
               
                
                
               
              //  Node.physicsBody?.contactTestBitMask = 1
            
            }
        }
        
        // Decrease Time
        if Waits == true {
        if GameClass.TimeEverySecond <= Int(time) {
            if GameClass.Time == 0 {
                
            }
            
            GameClass.DecreaseTime(Int(time))
            TimeLimit.text = "\(GameClass.Time)"
            if ColorChanged == true {
            TimeLimit.textColor = UIColor.white
            
                ColorChanged = false
            } else {
               
                TimeLimit.textColor = UIColor.black
                ColorChanged = true
            }
        }
        }
        
        
        
        
        
     //  let HitTest = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), types: .featurePoint)
        
        // TRACKING IS DONE
        
       
        
        if FinishedTracking == false {
        
            let HitTest = self.sceneView.hitTest(CGPoint(x: self.view.frame.midX , y: self.view.frame.midY), types: .existingPlaneUsingGeometry) // existingPlaneUsingExtent
            
            guard let result = HitTest.first else {return}
            let Translation = SCNMatrix4(result.worldTransform)
            let Position = SCNVector3(Translation.m41 , Translation.m42  , Translation.m43)
          
            
            if Tracking == nil {
                print("IT IS NIL")
                
                //Tracking.scn
                let Node = SCNScene(named: "art.scnassets/Tracking.scn")?.rootNode
                
                Tracking = Node
                
                sceneView.scene.rootNode.addChildNode(Tracking!)
                DiscriptionOfTheGame.text = "Plane detected: Tap to place"
            }
                Tracking?.position = Position
            
            }
        
        
       
        // CHECK IF LAST 3 WERE SAME
      //  Check()
        
        guard let track = Tracking?.position else {return}
        Tube.position = track
    }
    
    // DID BEGIN PHYICS CONTACT
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        //print("Let there be contact")
      
        
      
        if contact.nodeB.physicsBody?.contactTestBitMask == 2 && contact.nodeA.physicsBody?.contactTestBitMask == 7 {
            
            
            
            
            let  Ball = contact.nodeB
            let Box = contact.nodeA
            
        //  CurrentScore.text =  "\(GameClass.IncreaseBullets().0)" // THERE IS TIME AND BULLET 0 = BULLET
            let Explosions = SCNNode()
            
            // EXPLOSIONS IF HIT CORRECT NODE
            let Indexs = GameClass.CurrentWeaponChosed
            let WeaponsExplosions = WeaponUniqueFeatures.Name[Indexs].2

            let ExplosionsNode = SCNParticleSystem(named: "\(WeaponsExplosions)", inDirectory: nil)
            Explosions.position =  Box.presentation.position
            sceneView.scene.rootNode.addChildNode(Explosions)
            Explosions.addParticleSystem(ExplosionsNode!)
            
            
            let RunAction =  SCNAction.removeFromParentNode()
            Explosions.runAction(.sequence([ .wait(duration: 0.30) , RunAction ])) /// Fire Node
            
            /// Remove Actions Plus Parent Node
            Box.removeAllActions()
            Box.removeFromParentNode()
            Ball.removeFromParentNode()
            
            
            //  CHECK HIGH SCORE
            if CheckHighScore() {
                
            }
            
           
            
            
            
            let Index = NamesOfBoxesHit.Find(NamesOfBoxesHit ,  Ball.name!)
            
            if NamesOfBoxesHit.contains(Ball.name!) {
                
                // INCREASE SCORE BY THE GAME MODES SCORE
                let ScoreINcreaser = GameClass.GameMode[IndexNumebr].ScoreIncreasedBy
                GameClass.IncreaseScore(ScoreINcreaser)
                Score.text = "\(GameClass.Score)"
                
              
                
                
                ArrayForCheckLast3.append("Yes")
                CheckLast3(ArrayForCheckLast3)
                
                NamesOfBoxesHit.remove(at: Index)
            } else if NamesOfBoxesHit.contains(Box.name!) {
               
                // INCREASE SCORE BY THE GAME MODES SCORE
                let ScoreINcreaser = GameClass.GameMode[IndexNumebr].ScoreIncreasedBy
                GameClass.IncreaseScore(ScoreINcreaser)
                Score.text = "\(GameClass.Score)"
                NamesOfBoxesHit.remove(at: Index)
                
                ArrayForCheckLast3.append("Yes")
                CheckLast3(ArrayForCheckLast3)
                
            }
            
        }
        
        else if contact.nodeB.physicsBody?.contactTestBitMask == 3  && contact.nodeA.physicsBody?.contactTestBitMask == 7 || contact.nodeB.physicsBody?.contactTestBitMask == 7  && contact.nodeA.physicsBody?.contactTestBitMask == 3 {
           /// CurrentScore.text = "\(GameClass.DecreaseTimeAndBullet())"
            
            
            
            ArrayForCheckLast3.removeAll()
            
            let  Ball = contact.nodeB
            let Box = contact.nodeA
            
            
            let Index = NamesOfBoxesHit.Find(NamesOfBoxesHit ,  Ball.name!)
            
            if NamesOfBoxesHit.contains(Ball.name!) {
              
                
                GameClass.DecreaseTimeby2()
                TimeLimit.text = "\(GameClass.Time)"
                TimeLimit.textColor = UIColor.red
                
                
                
                
                
                TimeLimit.text = "\(GameClass.Time)"
                NamesOfBoxesHit.remove(at: Index)
 
            }
            else if NamesOfBoxesHit.contains(Box.name!) {
                
             
               GameClass.DecreaseTimeby2()
               TimeLimit.text = "\(GameClass.Time)"
               TimeLimit.textColor = UIColor.red
                
             
               
                
                TimeLimit.text = "\(GameClass.Time)"
                NamesOfBoxesHit.remove(at: Index)
            }

            
        }
        
        
        
    }
    

    
    
    
    
    // CHECK IF LAST 3 WERE SAME TO INCREASE TIME
    var Last3Nodes = [String]()
    var ArrayForCheckLast3  = [String]()
    func CheckLast3(_ array : [String]) {
        guard ArrayForCheckLast3.count > 3 else {return}
        let Last3 = array.count - 3
        print("Working")
        for (Index , string ) in array.enumerated() {
            if Index >= Last3 {
                print("THIS ")
                if string == array[array.count - 1] && string == array[array.count - 2] && string == array[array.count - 3] {
                    if Index == array.count - 1 {
                    GameClass.IfHit5andMoreIncreaseTime()
                    TimeLimit.text = "\(GameClass.Time)"
                    TimeLimit.textColor = UIColor.yellow
                    ArrayForCheckLast3.removeLast()
                    ArrayForCheckLast3.removeLast()
                    }
                    
                }
                
            }
        }
        
        
    }
    var PauseOrFinished = false
    
    @IBAction func PlayAgainifLost(_ sender: Any) {
        // RE START GAME WITH SCORES AND STUFF
        GameClass.PlayerGameData.EndGameSavings(Int(Score.text!)!)
        ReStartGame()
        // REMOVE THE EXTERNAL VIEW FROM THE VIEW
        
        StartAgainScreen()
       
    }
    
    @IBAction func GoBackScreen(_ sender: Any) {
        PauseGame()
        GameClass.PlayerGameData.EndGameSavings(Int(Score.text!)!)
        performSegue(withIdentifier: "GoBack", sender: nil)
      
    }
    
    
    var OnceHighScore = false
    
    
    @IBAction func PauseGamee(_ sender: Any) {
        ReasonsDueToPause.text = "! Paused !"
        Tracking?.removeFromParentNode()
        Tracking?.removeAllActions()
        PauseGame()
    }

    @IBOutlet weak var ContinueOutlet: UIButton!
    @IBAction func Continue(_ sender: Any) {
        StartAgainScreen()
        TimeLimit.isHidden = false
        CurrentScore.isHidden = false
    }
    
    
    
}


extension Array {
    func Find(_ array : [String]  , _ name : String) -> Int {
        
        
        for (Index , Name) in array.enumerated()  {
            if name == Name {
                return Index
            }
        }
        return 0
    }
}


// PAUSEE
extension ViewController {
    
   
    

    // CGECK IF PLAYERS UI FAR FROM CERATIN POINT
    // Y POSITion
    func Check() -> Bool {
        guard let TubePosition = Tracking?.position else { return true }
        let CameraNodes = sceneView.session.currentFrame!.camera
        
        // Y HOW HIGH IS HE FRO THE NODE
        let CameraY = CameraNodes.transform.columns.3.y
        let PositionY = TubePosition.y
        // Y CALCULATIONS
        var YCalculations = Float()
        if CameraY > PositionY {
            YCalculations = (CameraY - PositionY)
        } else {
            YCalculations = (PositionY - CameraY)
        }
        if abs(YCalculations) > 0.500 {
           DiscriptionOfTheGame.text = "Go Higher , Min Distance is 500cm from Node "
            return false
        } else {
           
            DiscriptionOfTheGame.text = ""
             return true
        }
        
    }
    // Z POSTIONS
    func CheckForZ() -> Bool {
        guard let TubePosition = Tracking?.position else { return true  }
        let CameraNodes = sceneView.session.currentFrame!.camera
        let CameraZ = CameraNodes.transform.columns.3.z
        let ZPosition = TubePosition.z
        // Z CALCULATIONS
        var Calculations = Float()
        if CameraZ < ZPosition {
            Calculations = CameraZ - ZPosition
        } else {
            Calculations = ZPosition - CameraZ
        }
        let PositiveNumber = abs(Calculations)
        
        if PositiveNumber < 0.4 { // IT IS OUTSIDE
            // DO SOMETHING // DID IN GUARD STATEMENT
            return false
        } else {
            // DO SOMETHING  IF LESS
            
            DiscriptionOfTheGame.text = ""
            return true
        }
    }
    
    
    
}

// BLUR EFFECT // RE START GAME
extension ViewController {
    func LossScreen() {
        UIView.animate(withDuration: 1.60 , animations: {
            
             self.VisualEffectLossScreen.transform = CGAffineTransform.identity
        })
        
        TimeLimit.isHidden = true
       
        CurrentScore.isHidden = true
        
        
        PauseOrFinished = true
        
        
       
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        

    }
    
    func StartAgainScreen() {
        UIView.animate(withDuration: 1.60 , animations: {
           
             self.VisualEffectLossScreen.transform = CGAffineTransform(translationX: 0, y: 1000)
        })
        PauseOrFinished = false
        GameClass.PausedGame = false
    }
    
    func ReStartGame() {
        TimeLimit.isHidden = false
        CurrentScore.isHidden = false
        
        DidAddTube = false
        Waits = false
        Tracking = nil
        FinishedTracking = false
        GameClass.Reset()
        GameClass.PausedGame = false
        TrackingNodeAddedTube = false
        Tubess.removeFromParentNode()
        print("Game money ")
        print(GameClass.PlayerGameData.Money)
        Score.text = "0"
        GameClass.PausedGame = false
        
        
    }
    
    
    func PauseGame() {
        TimeLimit.isHidden = false
        CurrentScore.isHidden = false
        ContinueOutlet.isHidden = false
        DidAddTube = false
        Waits = false
        Tracking = nil
        Tubess.removeFromParentNode()
        FinishedTracking = false
        TrackingNodeAddedTube = false
        PauseOrFinished = true
        GameClass.PausedGame = true 
        LossScreen()
        ReasonsDueToPause.text = "! Paused !"
    }
    
    
 
    
    
    func CheckHighScore() -> Bool { // if true blast or else dont
        let CurrentHighScore = GameClass.PlayerGameData.HighScore
        let PlayerData = GameClass.PlayerGameData.Data
        let CurrentScore = Int(Score.text!)!
        
        guard GameClass.FirstHighScore == true else { return false }
        
        if OnceHighScore == false   {
            DiscriptionOfTheGame.text = "! HIGH SCORE !"
            if CurrentHighScore < CurrentScore {
                PlayerData[0].highScore = Int64(CurrentScore)
                
                OnceHighScore = true
                
                for n in ArrayOfNodesCategory {
                    let Particle = SCNParticleSystem(named: "HighScoreParticles.scnp", inDirectory: nil)!
                    n.addParticleSystem(Particle)
                    
                }

                
            }
            return true
           
        } else {
            if CurrentHighScore < CurrentScore {
                PlayerData[0].highScore = Int64(CurrentScore)

            }
            return false
        }
        
        
       
        
        
        
        
        
    }
    
    
    
}


