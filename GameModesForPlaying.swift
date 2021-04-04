//
//  GameModesForPlaying.swift
//  PinBot
//
 
//  Copyright © 2018 Harshil Bhatt. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import CoreData

// COLOR   GAME MODEL
// PROTOCOL NEED TO BE FOLLOWED
struct ValuesNeeded {
    static let XRandomValue = [0.03 , -0.03 , 0.058 , -0.058 , 0.05 , -0.05 , 0.0 , 0.0]
}



protocol GameModesMinRequiresMents {
   
         var SecondsToChangeCurrentColor : Int { get set }
        var SecondsToChangeColor : Int {get set}
         var PositiveHit : String {get set}
        mutating func ChangeRandom()
         mutating func GenerateBox(position : SCNVector3 , Camera : ARCamera ) -> (SCNNode , Int , String)
        mutating func IfSoOrNotSo(_ Name : String  , PositveHit : String ) -> Bool
    var ScoreIncreasedBy : Int {get set}
    var Discription : String {get set}
   
    var Time : Double {get set }
    var HighScore : Int  {get set}
    var YForce : Double {get set}
        
}
// ALL LEVELS
struct ColorGameModel : GameModesMinRequiresMents  {
    var YForce: Double = 1.0
    
   
    var Discription : String = " ❗️Shoot Towards The Colored Boxes ❗️"
    var Time: Double = 50
    
   
    var ScoreIncreasedBy : Int = 1
   
    
    
    var ColorsToHit = ["Black" , "Red"  , "Yellow" , "Blue" , "Purple" , "White"] // THREE PLACES CHAGE
    var PositiveHit = String()// CURRENT COLOR TO HIT
    
    var SecondsToChangeCurrentColor = 5 /// Change Colors To hit Every 5 Second
    var SecondsToChangeColor : Int = 5 // THIS HELPS TO CHANGE SECONDS OF COLOR
    
    // GIVE COLOR AT EVERY 5 SECONDS
    mutating func ChangeRandom()  {
        let RandomColor = Int.random(in: 0..<ColorsToHit.count)
        PositiveHit = ColorsToHit[RandomColor]
    }
    // GENARATE BOX WITH DIFFRENT COLOR
    mutating func GenerateBox(position : SCNVector3 , Camera : ARCamera ) -> (SCNNode , Int , String)  {
        /// Shapes
        let Box = SCNBox(width: 0.121, height: 0.121, length: 0.121, chamferRadius: 0)
        let Circle = SCNSphere(radius: 0.1)
        let Toris = SCNPyramid(width: 0.123, height: 0.121, length: 0.121)
        /// Array of Shapes
        let Geomtry = [Box , Circle , Toris]
        /// Random
        let RandomGenoratorGeometry = Int.random(in : 0..<Geomtry.count) /// For Random Shape
        let NodeChosen = Geomtry[RandomGenoratorGeometry] /// Shapes
        let Node = SCNNode(geometry: Geomtry[RandomGenoratorGeometry]) /// Nodes
        /// Give angles to Shapes which need
        
        if RandomGenoratorGeometry == 2 {
            Node.eulerAngles.x = Float(-90.DegreesToRadians)
        }
        
        
        
        /// Create RandomBox
        
        
        var ArrayOfColors =   [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) , #colorLiteral(red: 0.7518713663, green: 0.3134157188, blue: 0.2304346555, alpha: 1), #colorLiteral(red: 0.9334847384, green: 0.6073300868, blue: 0.2387236325, alpha: 1) , #colorLiteral(red: 0.2202243784, green: 0.121884609, blue: 0.9334847384, alpha: 1) , #colorLiteral(red: 0.4955299302, green: 0.07746424496, blue: 0.9334847384, alpha: 1)  , #colorLiteral(red: 0.8371415871, green: 0.7841937512, blue: 0.9334847384, alpha: 1)] // CHANGE THREE PLACES
       
        var ColorsString = ["Black" , "Red"  , "Yellow" , "Blue" , "Purple" , "White"] // CHange three places
        ArrayOfColors.append(PositiveHit.ConvertColorStringToColor())
        ArrayOfColors.insert(PositiveHit.ConvertColorStringToColor() , at: 0)
        ArrayOfColors.insert(PositiveHit.ConvertColorStringToColor() , at: 0)
       
        ColorsString.append(PositiveHit)
        ColorsString.insert(PositiveHit, at: 0)
        ColorsString.insert(PositiveHit, at: 0)
    // Here
        
        
        
        
        
        let RandomGenorator = Int.random(in : 0..<ArrayOfColors.count)
        NodeChosen.firstMaterial?.diffuse.contents = ArrayOfColors[RandomGenorator]
        
        
       
        
        /// Position
        Node.position = position
        Node.GiveBasicValue(Camera , ArrayOfColors[RandomGenorator], YForce)
        
        //// If the Node is what the colors have to hit
        if ColorsString[RandomGenorator] == PositiveHit {
            return (Node , 2  , ColorsString[RandomGenorator])
        }
        
        
        return (Node , 3 , ColorsString[RandomGenorator])
    }
    mutating func IfSoOrNotSo(_ Name : String  , PositveHit : String ) -> Bool {
        if Name == PositveHit {
            return true
        } else {
            return false
        }
    }
    
    var HighScore : Int = 0
    
    mutating func ConstatCheckforHighScore() -> (Bool , Int){
        if GameClass.Score > HighScore {
            HighScore = GameClass.Score
            return (true , HighScore)
        }
        return (false  , HighScore)
    }
    
    mutating func GetHighScore(HighScores : Int) {
        HighScore = HighScores
    }
}
// SECOND LEVEL
struct ShapeGameModel : GameModesMinRequiresMents  {
    var YForce : Double = (1.2)
     var Discription : String = " ❗️Shoot Towards The Shapes ❗️"
    var ScoreIncreasedBy : Int = 1
    var Time: Double = 70
    
    var SecondsToChangeCurrentColor = 5 /// Change Colors To hit Every 5 Second
    var SecondsToChangeColor = 5
    
    var Shapes = ["box" , "circle" , "toris" , "pyramid"]
    var PositiveHit = String()
    // GET RANDOM BOXES
    mutating func ChangeRandom() {
        let Random = Int.random(in: 0..<Shapes.count)
        PositiveHit = Shapes[Random]
        
    }
    mutating func GenerateBox(position : SCNVector3 , Camera : ARCamera ) -> (SCNNode , Int , String) {
        var RandomShapes = ["box".ConvertToShape() , "circle".ConvertToShape() , "toris".ConvertToShape() , "pyramid".ConvertToShape()]
        var ShapesName = ["box" , "circle" , "toris" , "pyramid"]
        let Node = SCNNode()
        // Generate numebr
        let RandomNumber = Int.random(in: 0..<RandomShapes.count)
        
        
        
        
        ShapesName.insert(PositiveHit, at: 0)
        ShapesName.append(PositiveHit)
        RandomShapes.append(PositiveHit.ConvertToShape())
        RandomShapes.insert(PositiveHit.ConvertToShape(), at: 0)
        Node.geometry = RandomShapes[RandomNumber]
        
        // Random Shape
        
        Node.geometry = RandomShapes[RandomNumber]
        Node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        // POSITIONS
        Node.position = position
        
        // FORCE and PHYSICS
        Node.GiveBasicValue(Camera , UIColor.red, YForce)
        // NUMBER
        // COLOR
        
        if ShapesName[RandomNumber] == PositiveHit {
            return (Node  , 2 , ShapesName[RandomNumber])
        }
        
        
        return (Node , 3 ,  ShapesName[RandomNumber])
    }
    
    mutating func IfSoOrNotSo(_ Name : String  , PositveHit : String ) -> Bool {
        if Name == PositveHit {
            return true
        } else {
            return false
        }
    }
    
    var HighScore : Int = 0
    mutating func ConstatCheckforHighScore() -> (Bool , Int){
        if GameClass.Score > HighScore {
            HighScore = GameClass.Score
            return (true , HighScore)
        }
        return (false  , HighScore)
    }
    
    mutating func GetHighScore(HighScores : Int) {
        HighScore = HighScores
    }
}
// Third Level
struct ColorWithShapeModel : GameModesMinRequiresMents {
    var YForce: Double = 1.3
    
    
    
     var Discription : String = "❗️Shoot Towards The Colored Shapes❗️"
    
    var ScoreIncreasedBy : Int = 2
    var Time: Double = 90.0
    
    var SecondsToChangeCurrentColor: Int = 6
    var SecondsToChangeColor: Int = 6
    
    var PositiveHit =  String()
    
    let ColorsShape = ["Black" , "Red"  , "Yellow" , "Blue" , "Purple" , "White"]
    let Shape = ["box" , "circle" , "toris" , "pyramid"]
    
    private var ColorsNumeber = 0
    private var ShapeNumber = 0
    
    mutating func ChangeRandom() {
        let Random = Int.random(in: 0..<ColorsShape.count)
        let Randoms = Int.random(in: 0..<Shape.count)
        
        ColorsNumeber = Random
        ShapeNumber = Randoms
        
        PositiveHit = "\(ColorsShape[Random]) \(Shape[Randoms])"
    }
    
    mutating func GenerateBox(position: SCNVector3, Camera: ARCamera) -> (SCNNode, Int, String) {
        var Shapes = ["box" , "circle" , "toris" , "pyramid"]
        var Colors = ["Black" , "Red"  , "Yellow" , "Blue" , "Purple" , "White"]
        Shapes.append(Shape[ShapeNumber])
        Shapes.insert(Shape[ShapeNumber], at: 0)
        Shapes.insert(Shape[ShapeNumber], at: 3)
        Shapes.insert(Shape[ShapeNumber], at: 4)
        
        Colors.append(ColorsShape[ColorsNumeber])
        Colors.insert(ColorsShape[ColorsNumeber], at: 0)
        Colors.insert(ColorsShape[ColorsNumeber], at: 3)
        Colors.insert(ColorsShape[ColorsNumeber], at: 4)
      
        
        let RandomShape = Int.random(in: 0..<Shapes.count)
        let RandomColor = Int.random(in: 0..<Colors.count)
        
        let Node = SCNNode()
        Node.geometry = Shapes[RandomShape].ConvertToShape()
        Node.geometry?.firstMaterial?.diffuse.contents = Colors[RandomColor].ConvertColorStringToColor()
        
        
        
        
        Node.position = position
        Node.GiveBasicValue(Camera , Colors[RandomColor].ConvertColorStringToColor() , YForce)
        
        let NodesName =  "\(Colors[RandomColor]) \(Shapes[RandomShape])"
        
        if PositiveHit == NodesName {
            return (Node , 2 , NodesName)
        }
        return (Node , 3 , NodesName)
    }
    
    func IfSoOrNotSo(_ Name: String, PositveHit: String) -> Bool {
        if Name == PositveHit {
            return true
        } else {
            return false
        }
    }
    
    var HighScore : Int = 0
    
    mutating func ConstatCheckforHighScore() -> (Bool , Int){
        if GameClass.Score > HighScore {
            HighScore = GameClass.Score
            return (true , HighScore)
        }
        return (false  , HighScore)
    }
    
    mutating func GetHighScore(HighScores : Int) {
        HighScore = HighScores
    }
    
}

struct NotColorType : GameModesMinRequiresMents {
    var SecondsToChangeCurrentColor: Int = 4
    
    var SecondsToChangeColor: Int = 4
    
    var PositiveHit = String()
    
    var ScoreIncreasedBy: Int = 2
    
    var Discription: String = "Dont hit the colors given"
    
    var Time: Double = 120.0
    
    var HighScore: Int = 0
    
    var YForce: Double = 1.4
    
    let ColorsNotToHIt = ["Black" , "Red"  , "Yellow" , "Blue" , "Purple" , "White"]
    
    mutating func ChangeRandom() {
        let RandomColor = Int.random(in: 0..<ColorsNotToHIt.count)
        PositiveHit = ColorsNotToHIt[RandomColor]
    }
    
    mutating func GenerateBox(position: SCNVector3, Camera: ARCamera) -> (SCNNode, Int, String) {
        /// Shapes
        let Box = SCNBox(width: 0.121, height: 0.121, length: 0.121, chamferRadius: 0)
        let Circle = SCNSphere(radius: 0.1)
        let Toris = SCNPyramid(width: 0.123, height: 0.121, length: 0.121)
        let Pyramid = SCNTorus(ringRadius: 0.084, pipeRadius: 0.013)
        /// Array of Shapes
        let Geomtry = [Box , Circle , Toris , Pyramid]
        /// Random
        let RandomGenoratorGeometry = Int.random(in : 0..<Geomtry.count) /// For Random Shape
        let NodeChosen = Geomtry[RandomGenoratorGeometry] /// Shapes
        let Node = SCNNode(geometry: Geomtry[RandomGenoratorGeometry]) /// Nodes
        /// Give angles to Shapes which need
        
        if RandomGenoratorGeometry == 2 {
            Node.eulerAngles.x = Float(-90.DegreesToRadians)
        }
        
        
        
        /// Create RandomBox
        
        
        var ArrayOfColors =   [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) , #colorLiteral(red: 0.7518713663, green: 0.3134157188, blue: 0.2304346555, alpha: 1), #colorLiteral(red: 0.9334847384, green: 0.6073300868, blue: 0.2387236325, alpha: 1) , #colorLiteral(red: 0.2202243784, green: 0.121884609, blue: 0.9334847384, alpha: 1) , #colorLiteral(red: 0.4955299302, green: 0.07746424496, blue: 0.9334847384, alpha: 1)  , #colorLiteral(red: 0.8371415871, green: 0.7841937512, blue: 0.9334847384, alpha: 1)] // CHANGE THREE PLACES
        
        var ColorsString = ["Black" , "Red"  , "Yellow" , "Blue" , "Purple" , "White"] // CHange three places
        ArrayOfColors.append(PositiveHit.ConvertColorStringToColor())
        ArrayOfColors.insert(PositiveHit.ConvertColorStringToColor() , at: 0)
        ArrayOfColors.insert(PositiveHit.ConvertColorStringToColor() , at: 1)
        ArrayOfColors.insert(PositiveHit.ConvertColorStringToColor() , at: 2)
        
        ColorsString.append(PositiveHit)
        ColorsString.insert(PositiveHit, at: 0)
        ColorsString.insert(PositiveHit, at: 1)
        ColorsString.insert(PositiveHit, at: 2)
        // Here
        
        
        
        
        
        let RandomGenorator = Int.random(in : 0..<ArrayOfColors.count)
        NodeChosen.firstMaterial?.diffuse.contents = ArrayOfColors[RandomGenorator]
        
        
        
        
        /// Position
        Node.position = position
        Node.GiveBasicValue(Camera , ArrayOfColors[RandomGenorator], YForce)
        
        //// If the Node is what the colors have to hit
        if ColorsString[RandomGenorator] != PositiveHit {
            return (Node , 2  , ColorsString[RandomGenorator])
        }
        
        
        return (Node , 3 , ColorsString[RandomGenorator])
    }
    
    func IfSoOrNotSo(_ Name: String, PositveHit: String) -> Bool {
        if Name != PositveHit {
            return true
        } else {
            return false
        }
    }
    
   
    
    
}

struct AnyThing : GameModesMinRequiresMents {
    var SecondsToChangeCurrentColor: Int = 4
    
    var SecondsToChangeColor: Int = 5
    
    var PositiveHit = String()
    
    let Shapes = ["box" , "circle" , "toris" , "pyramid" , "Capsule" , "Cylinder"]
    let Colors =  ["Black" , "Red"  , "Yellow" , "Blue" , "Purple" , "White"]
    var Nm = Int()
    mutating func ChangeRandom() {
        
        //let ActualRandom = Int.random(in: 0..<Random.count)
        let Names = [Shapes , Colors]
        let RandomS = Int.random(in: 0..<Names.count)
        
        
        Nm = Int.random(in: 0..<Names[RandomS].count)
        let Random = [Shapes[Nm] , Colors[Nm], "\(Colors[Nm]) \(Shapes[Nm])"]
        
        let RandomNumber = Int.random(in: 0..<Random.count)
        PositiveHit = Random[RandomNumber]
        
        
    }
    
    func GenerateBox(position: SCNVector3, Camera: ARCamera) -> (SCNNode, Int, String) {
        let Node = SCNNode()
        var RandomColor = Colors
        var Shapess = Shapes
        
        RandomColor.append(Colors[Nm])
        RandomColor.append(Colors[Nm])
        RandomColor.append(Colors[Nm])
        
        Shapess.append(Shapes[Nm])
        Shapess.append(Shapes[Nm])
        Shapess.append(Shapes[Nm])
        
        let RandomColorsNumeber = Int.random(in: 0..<RandomColor.count)
        let RandomShapesColor = Int.random(in: 0..<Shapess.count)
        
        Node.position = position
        Node.geometry = Shapess[RandomShapesColor].ConvertToShape()
        Node.GiveBasicValue(Camera, RandomColor[RandomColorsNumeber].ConvertColorStringToColor(), YForce)
        
        Node.geometry?.firstMaterial?.diffuse.contents = RandomColor[RandomColorsNumeber].ConvertColorStringToColor()
       /*
                    POSITV E HIT = RED BOX
                    NODE NAME = RED PYRAMID
         
                    POSITIVE HIT = RED
                    NODE NAME = RED BOX
         
                    POSTIVE HIT = YELLOW BOX
                    NODE NAME  = YELLOW
         
         IF POSTIVE HIT ==  NODE NAME {} IF NODENAME.CONTAINS(POSTIVEHIT) {}
         
        */
        let NodesName = "\(RandomColor[RandomColorsNumeber]) \(Shapess[RandomShapesColor])"
        
        if PositiveHit == NodesName || NodesName.contains(PositiveHit) {
            return (Node , 2 , NodesName)
        } else {
            return (Node , 3 , NodesName)
        }
        
        
        
        
       
        
        
    }
    
    func IfSoOrNotSo(_ Name: String, PositveHit: String) -> Bool {
        if PositiveHit == Name || Name.contains(PositiveHit) {
            return true
        } else {
            return false
        }
    }
    
    var ScoreIncreasedBy: Int = 2
    
    var Discription: String = "Hit the directions given above"
    
    var Time: Double = 150
    
    var HighScore: Int = 0
    
    var YForce: Double = 1.3
    
    
}

extension String {
    // CONVERT COLORS STRING TO COLOR
    func ConvertColorStringToColor() -> UIColor {
        switch self {
            
        case "Red":
            return #colorLiteral(red: 0.9122274709, green: 0.3632576412, blue: 0.4349083561, alpha: 1)
            
            
        case "Blue":
            return #colorLiteral(red: 0.4491503637, green: 0.5398431009, blue: 0.8661882267, alpha: 1)
            
            
        case "Yellow":
            return #colorLiteral(red: 0.79609375, green: 0.5770042223, blue: 0.1530711196, alpha: 1)
            
            
        case "Purple":
            return #colorLiteral(red: 0.3744071606, green: 0.05380142884, blue: 0.6875726744, alpha: 1)
            
            
        case "White":
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            
        case "Black" :
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // THERE IS A BLACK COLOR
            
        case "orange" :
            return #colorLiteral(red: 1, green: 0.2660339032, blue: 0.2702682032, alpha: 1)
        case "Green" :
            return #colorLiteral(red: 0.5095355662, green: 0.7007994186, blue: 0.1604332265, alpha: 1)
        default:
            return UIColor.green
        }
        
        
    }
    // SHAPES STRING TO SCN SHAPES
    func ConvertToShape() -> SCNGeometry  {
        switch self {
        case "box" :
            return SCNBox(width: 0.121, height: 0.121, length: 0.121, chamferRadius: 0)
        case "circle" :
            return SCNSphere(radius: 0.1)
        case "toris" :
            return SCNTorus(ringRadius: 0.084, pipeRadius: 0.013)
        case "pyramid" :
            return SCNPyramid(width: 0.121, height: 0.121, length: 0.121)
        case "Cylinder" :
            return SCNCylinder(radius: 0.121, height: 0.3)
        case "Capsule" :
            return SCNCapsule(capRadius: 0.121, height: 0.4)
    
        default :
            return SCNText(string: "SomethingWrong", extrusionDepth: 0.3)
        }
    }
    
    // CONVERT TO NUMBER
    func ConvertToInt() -> Int {
        return Int(self)!
    }
    
}

extension SCNNode {
    // FORCE and PHYSICS
    
    func GiveBasicValue(_ Camera : ARCamera , _  Color : UIColor  , _ YForce : Double) {
    
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody = .dynamic()
        let XRandomValue = ValuesNeeded.XRandomValue
        let XRandom = Int.random(in: 1..<XRandomValue.count)
        let Forces = SCNVector3(XRandomValue[XRandom], YForce , 0)
        self.physicsBody?.applyForce(Forces, asImpulse: true)
        /// Angles
        let BilBoard = SCNBillboardConstraint()
        BilBoard.freeAxes = [.X , .Y , .Z]
        self.constraints = [BilBoard]
        
        // ANGLES
        let XGiven = Camera.eulerAngles.x
        let YGiven = Camera.eulerAngles.y
        let NewRotation = SCNVector4(XGiven, YGiven, (Camera.eulerAngles.z) , 45)
        self.physicsBody?.isAffectedByGravity = false
        self.rotation = NewRotation
        self.physicsBody?.isAffectedByGravity = false
        
        let Remove = SCNAction.removeFromParentNode()
        let Hide = SCNAction.fadeOut(duration: 0.3)
        self.runAction(.sequence([.wait(duration: 7) , Hide , .wait(duration : 5) , Remove]))
        
        let Particles = SCNParticleSystem(named: "BoxParticles.scnp", inDirectory: nil)
        self.addParticleSystem(Particles!)
        
        
        
        self.geometry?.firstMaterial?.normal.contents = Color
        self.geometry?.firstMaterial?.transparent.contents = Color
        self.geometry?.firstMaterial?.ambientOcclusion.contents = Color
        self.geometry?.firstMaterial?.selfIllumination.contents = Color
        self.geometry?.firstMaterial?.emission.contents = Color
        self.geometry?.firstMaterial?.displacement.contents = Color
        
       self.geometry?.firstMaterial?.cullMode = .front
        
    }
}

extension Int {
    // NAME TO TEXT
    func ConvertToNumbers() -> SCNGeometry {
        let TextNode = SCNText(string: "\(self)", extrusionDepth: 0.03) //SCNText(string: "\(self)" , extrusionDepth: 1.1)
        
        let font = UIFont(name: "Futura", size: 0.57)
        
        TextNode.font = font
        
        
        TextNode.firstMaterial?.diffuse.contents = UIColor.orange
        TextNode.firstMaterial?.specular.contents = UIColor.white
        TextNode.firstMaterial?.isDoubleSided = true
        TextNode.chamferRadius = CGFloat(0.007)


        return TextNode
    }
}




