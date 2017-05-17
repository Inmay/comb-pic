//
//  parallelogramCover.swift
//  组合图片
//
//  Created by WuYueFeng on 2017/5/17.
//  Copyright © 2017年 WuYueFeng. All rights reserved.
//

import UIKit

class parallelogramCover: CALayer {
    
    let angle = Double( 40 / 180.0 * .pi )//左上角
    
    var pointE:CGPoint!
    var pointF:CGPoint!
    
    override func draw(in ctx: CGContext) {
        
        let pointA = CGPoint.init(x: 0, y: 0)
        let pointB = CGPoint.init(x: self.bounds.width, y: 0)
        let pointC = CGPoint.init(x: self.bounds.width, y: self.bounds.height)
        let pointD = CGPoint.init(x: 0, y: self.bounds.height)
        
     
            
        
        //let pointE = CGPoint.init(x:  CGFloat(tan(30.0))*self.bounds.height,y:self.bounds.height)
        
        
        
        
//         pointF = CGPoint.init(x: pointE.x, y: 0)//不规则图型
        
        
        
        
        
        let ovalPath = UIBezierPath()
        ovalPath.move(to: pointA)
        ovalPath.addLine(to: pointE)
        ovalPath.addLine(to: pointD)
        ovalPath.close()
        
        ovalPath.move(to: pointB)
        ovalPath.addLine(to: pointC)
        ovalPath.addLine(to: pointF)
        ovalPath.close()
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.addPath(ovalPath.cgPath)
        ctx.drawPath(using: CGPathDrawingMode.fillStroke)
        
        
    }
    
}
