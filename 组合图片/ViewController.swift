//
//  ViewController.swift
//  组合图片
//
//  Created by WuYueFeng on 2017/5/17.
//  Copyright © 2017年 WuYueFeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBAction func getPic(_ sender: Any) {
        //3.0有问题
//        let vc = PhotoLibraryViewController.Alert { (imgs) in
//            
//        }
//        self.present(vc, animated: true, completion: nil)
        
        let vc = UIImagePickerController.init()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        imagenPred.image = UIImage.init(data: UIImagePNGRepresentation(image)!)
        self.dismiss(animated: false, completion: nil)
    }
   
    @IBAction func topPointMove(_ sender: UISlider) {
        cover.pointF = CGPoint.init(x: CGFloat(sender.value)*cover.bounds.width, y: 0)
        cover.setNeedsDisplay()
    }
    

    @IBAction func downPointMove(_ sender: UISlider) {
        
        cover.pointE = CGPoint.init(x: CGFloat(sender.value)*cover.bounds.width, y: cover.bounds.height)
        cover.setNeedsDisplay()
    }
    
    @IBOutlet weak var imagenPred: UIImageView!
    
    var cover:parallelogramCover!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagenPred.image = UIImage.init(name: .into)
        
        cover = parallelogramCover.init()
        cover.frame = CGRect.init(x: 0, y: 0, width: imagenPred.bounds.width, height: imagenPred.bounds.height)
        cover.pointE = CGPoint.init(x:cover.bounds.width/2,y:cover.bounds.height)
        cover.pointF = CGPoint.init(x: cover.pointE.x, y: 0)
        imagenPred.layer.addSublayer(cover)
        cover.setNeedsDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func typeSelect(model:Int){
        switch model {
        case 1:  //A.平行四边形
            break
//            if imagenPred.layer.sublayers != nil {
//                for oldLayer in imagenPred.layer.sublayers! {
//                    oldLayer.removeFromSuperlayer()
//                }
//            }
//            
//            let layer = parallelogramCover.init()
//            layer.frame = CGRect.init(x: 0, y: 0, width: imagenPred.bounds.width, height: imagenPred.bounds.height)
//            imagenPred.layer.addSublayer(layer)
//            layer.setNeedsDisplay()
        default:()
        }
    }
    
    @IBAction func modelASelected(_ sender: UIButton) {
        typeSelect(model: sender.tag)
    }
    
}

