//
//  InstructionsView.swift
//  PinBot
//
 
//  Copyright © 2018 Harshil Bhatt. All rights reserved.
//

import UIKit
import ARKit

class InstructionsView: UIViewController , ARSCNViewDelegate , SCNPhysicsContactDelegate {

    @IBOutlet weak var ColorsDemo: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    var SecondsToChange = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        let Scene = SCNScene()
        sceneView.scene = Scene
        // Do any additional setup after loading the view.
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    
        if SecondsToChange <= (time) {
            SecondsToChange = time  + 1.5
            let Colors = ["Red" , "Orange" , "Yellow" , "White" , "Black"]
            let RandomInt = Int.random(in: 0..<Colors.count)    
            ColorsDemo.text = "\(Colors[RandomInt])"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
