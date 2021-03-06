//
//  ViewController.swift
//  Neighborhood
//
//  Created by Cindy Bishop on 10/17/18.
//  Copyright © 2018 LoopyLoo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import PocketSVG


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        guard let referenceMaps = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionImages = referenceMaps
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func svgParse(resourcePath: String) -> SVGImageView{
        
        let url = Bundle.main.url(forResource: "cambridge_census_tracts", withExtension: "svg")!
        let svgImageView = SVGImageView(contentsOf: url)
        svgImageView.frame = self.view.bounds
        
        return svgImageView
    }

    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !(anchor is ARImageAnchor) {
            return
        }
        let imageAnchor = anchor as? ARImageAnchor
        let svgView = svgParse(resourcePath: "tiger.svg")
        let referenceImage = imageAnchor?.referenceImage
        DispatchQueue.main.async {

            let tempCollageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
            tempCollageView.layer.bounds = CGRect(x: -450, y: -450, width: tempCollageView.frame.size.width, height: tempCollageView.frame.size.height)
            tempCollageView.image = UIImage(data: UIImage(named: "mapwork.png")?.pngData() ?? Data())

            let imageMaterial = SCNMaterial()
            //imageMaterial.diffuse.contents = UIImage(named: "mapwork.png")
            imageMaterial.isDoubleSided = true
            imageMaterial.diffuse.contents = tempCollageView.layer
            
            /*let translation = SCNMatrix4MakeTranslation(0, 0, 0)
            let rotation = SCNMatrix4MakeRotation(Float.pi / 2, 0, 0, 1)
            let transform = SCNMatrix4Mult(translation, rotation)
            imageMaterial.diffuse.contentsTransform = transform */
            // Create a plane to visualize the initial position of the detected image.
            let planeCollage = SCNPlane(width: referenceImage!.physicalSize.width,
                                 height: referenceImage!.physicalSize.height)
            planeCollage.materials = [imageMaterial]
            

            let planeCollageNode = SCNNode(geometry: planeCollage)
            planeCollageNode.opacity = 0.5
            planeCollageNode.eulerAngles.x = -.pi / 2

            
            let plane = SCNPlane(width: referenceImage!.physicalSize.width,
                                           height: referenceImage!.physicalSize.height)
            
            // maybe use this to create a shape like the svg shape and color it green
            /*let shape = CAShapeLayer()
            shape.opacity = 0.5
            shape.lineWidth = 2
            shape.lineJoin = CAShapeLayerLineJoin.miter
            shape.strokeColor = UIColor(red: 0, green: 255, blue: 0, alpha: 255).cgColor
            shape.fillColor = UIColor(red: 0, green: 255, blue: 0, alpha: 255).cgColor
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 250, y: 320))
            path.addLine(to: CGPoint(x: 260, y: 320))
            path.addLine(to: CGPoint(x: 200, y: -1000))
            path.addLine(to: CGPoint(x: 100, y: -1000))
            path.close()
            shape.path = path.cgPath*/
            
            //svgView.layer.transform = CATransform3DTranslate(rotation, 20, 30, 0)
            
            //let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: 900, height: 900))
            //tempView.layer.bounds = CGRect(x: -450, y: -450, width: tempView.frame.size.width, height: tempView.frame.size.height)
            //tempView.layer.addSublayer(shape)
            //tempView.backgroundColor = UIColor.clear
            let newMaterial = SCNMaterial()
            newMaterial.blendMode = SCNBlendMode.add // if multiply it turns everything green
            //newMaterial.multiply.contents = tempView.layer //- nice affect with poloygon
            //newMaterial.emission.contents = svgView.layer // nice affect to color everything green
            newMaterial.diffuse.contents = svgView.layer
            newMaterial.isDoubleSided = true
            newMaterial.transparency = 1
            plane.materials = [newMaterial]
            

            
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 1
            
            planeNode.eulerAngles.z = -360 * .pi / 180
            planeNode.eulerAngles.x = .pi / 2
            planeNode.position.x = -0.03
            planeNode.position.y = -0.01
            planeNode.position.z = -0.02 //offset
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, but
             `ARImageAnchor` assumes the image is horizontal in its local space, so
             rotate the plane to match.
             */

            
            /*
             Image anchors are not tracked after initial detection, so create an
             animation that limits the duration for which the plane visualization appears.
             */
            //planeNode.runAction(self.imageHighlightAction)
            
            // Add the plane visualization to the scene.
            
            node.addChildNode(planeCollageNode)
            node.addChildNode(planeNode)
        }
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
