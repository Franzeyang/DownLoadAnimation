//
//  animation.swift
//  17Animation
//
//  Created by franze on 2017/5/27.
//  Copyright © 2017年 franze. All rights reserved.
//

import UIKit

extension UIView{
    func position()->CGPoint{
        return (layer.presentation()?.position)!
    }
}

class animation: UIButton {
    var c:UIView!
    var shape:CAShapeLayer!
    var lshape:CAShapeLayer!
    var circle:CAShapeLayer!
    var reLayer:CAReplicatorLayer!
    var link:CADisplayLink!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initialize(){
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 20
//        layer.masksToBounds = true
        
        link = CADisplayLink(target: self, selector: #selector(updatePath))
        link.add(to: .current, forMode: .commonModes)
        link.isPaused = true
        
        circle = CAShapeLayer()
        circle.strokeColor = UIColor.black.cgColor
        circle.fillColor = UIColor.lightGray.cgColor
        circle.lineWidth = 2
        layer.addSublayer(circle)
        
        shape = CAShapeLayer()
        shape.path = getSpecificPath(path: "line_three")
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.lightGray.cgColor
        shape.backgroundColor = UIColor.red.cgColor
        shape.lineWidth = 1
        shape.lineJoin = "round"
        shape.lineCap = "round"
        layer.addSublayer(shape)
        
        lshape = CAShapeLayer()
        lshape.strokeColor = UIColor.black.cgColor
        lshape.lineJoin = "round"
        lshape.lineCap = "round"
        lshape.path = getSpecificPath(path: "init")
        layer.addSublayer(lshape)
        
        c = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        c.center = CGPoint(x: bounds.width/2, y: bounds.width/2)
        addSubview(c)
    }
    
    func start(){
        let anim =  CABasicAnimation(keyPath: "path")
        anim.duration = 0.5
//        anim.fromValue = getSpecificPath(path: "init")
//        anim.toValue = getSpecificPath(path: "final")
        lshape.path = getSpecificPath(path: "final")
        
        let translateAnim = CAKeyframeAnimation(keyPath: "position")
        translateAnim.beginTime = 0.5
        translateAnim.duration = 0.7
        translateAnim.path = getSpecificPath(path: "path")
        translateAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.200000, 0.503333, 1.0, 0.390000)
        
        let fgroup = CAAnimationGroup()
        fgroup.animations = [anim,translateAnim]
        fgroup.duration = 1.2
        fgroup.fillMode = kCAFillModeForwards
        fgroup.isRemovedOnCompletion = false
        lshape.add(fgroup, forKey: nil)
        
        let pathAnim_down = CABasicAnimation(keyPath: "path")
        pathAnim_down.duration = 0.2
        pathAnim_down.fromValue = shape.path
        pathAnim_down.toValue = getSpecificPath(path: "down")
        
        let pathAnim_line = CABasicAnimation(keyPath: "path")
        pathAnim_line.beginTime = 0.2
        pathAnim_line.duration = 0.2
        shape.path = getSpecificPath(path: "line")
        
        let group = CAAnimationGroup()
        group.animations = [pathAnim_down,pathAnim_line]
        group.duration = 0.4
        shape.add(group, forKey: nil)
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.4))
        
        self.link.isPaused = false
        
        UIView.animate(withDuration: 0.08, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: [], animations: {
            self.c.center.y -= 5
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [], animations: {
                self.c.center.y += 5
            }, completion: { (_) in
                self.stop()
                self.shape.path = self.getSpecificPath(path: "dot")
                let pathAnim_doc = CABasicAnimation(keyPath: "path")
                pathAnim_doc.duration = 0.25
                pathAnim_doc.fromValue = self.getSpecificPath(path: "line_two")
                pathAnim_doc.toValue = self.getSpecificPath(path: "dot")
                self.shape.add(pathAnim_doc, forKey: nil)
            })
        }
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.49))
        
        reLayer = CAReplicatorLayer()
        reLayer.frame = CGRect(x: bounds.width/2, y: bounds.height/2, width: 1, height: 1)
        reLayer.instanceCount = 4
        reLayer.transform = CATransform3DMakeRotation(.pi/180*45, 0, 0, 1)
        reLayer.instanceTransform = CATransform3DMakeRotation(.pi/180*90, 0, 0, 1)
        layer.addSublayer(reLayer)
    
        let mlayer = CAShapeLayer()
        mlayer.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        mlayer.backgroundColor = UIColor.black.cgColor
        mlayer.transform = CATransform3DMakeScale(1, 20, 1)
        reLayer.addSublayer(mlayer)
        
        let transformAnim = CABasicAnimation(keyPath: "transform")
        transformAnim.duration = 0.3
        transformAnim.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
        transformAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 20, 1))
        transformAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        mlayer.add(transformAnim, forKey: nil)
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.45))
            
        let circleanim = CABasicAnimation(keyPath: "strokeEnd")
        circleanim.fromValue = 0
        circleanim.duration = 1
        circle.path = UIBezierPath(arcCenter: CGPoint(x:bounds.width/2,y:bounds.width/2), radius: 20, startAngle: .pi/180*(-90), endAngle: .pi/180*270, clockwise: true).cgPath
        circle.add(circleanim, forKey: nil)
    }
    
    func stop(){
        if link != nil{
            link.invalidate()
        }
        shape.removeAllAnimations()
    }
    
    func updatePath(){
        shape.path = getPath()
    }
    
    //初始形状
    
    func getSpecificPath(path string:String)->CGPath{
        let W = bounds.width
        let path = UIBezierPath()
        switch string {
        case "line_three":
            path.move(to: CGPoint(x: W*0.34, y: W*0.55))
            path.addLine(to: CGPoint(x: W/2, y: W*0.74))
            path.addLine(to: CGPoint(x: W*0.66, y: W*0.55))
        case "down":
            path.move(to: CGPoint(x: W*0.34, y: W*0.55+3))
            path.addLine(to: CGPoint(x: W/2, y: W*0.74+3))
            path.addLine(to: CGPoint(x: W*0.66, y: W*0.55+3))
        case "line":
            path.move(to: CGPoint(x: W*0.2, y: W/2))
            path.addLine(to: CGPoint(x: W/2, y: W/2))
            path.addLine(to: CGPoint(x: W*0.8, y: W/2))
        case "line_two":
            path.move(to: CGPoint(x: W*0.2, y: W/2))
            path.addLine(to: CGPoint(x: W*0.8, y: W/2))
        case "dot":
            path.move(to: CGPoint(x: W/2, y: W/2))
            path.addLine(to: CGPoint(x: W/2, y: W/2))
        case "init":
            path.move(to: CGPoint(x: W/2, y: W*0.24))
            path.addLine(to: CGPoint(x: W/2, y: W*0.74))
        case "final":
            path.move(to: CGPoint(x: W/2, y: W/2-4))
            path.addLine(to: CGPoint(x: W/2, y: W/2-2))
        case "path":
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: -24))
            path.addLine(to: CGPoint(x: 0, y: -17))
        default:()
        }
        return path.cgPath
    }
    
    //实时形状
    func getPath()->CGPath{
        let W = bounds.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: W*0.2, y: W/2))
        path.addQuadCurve(to: CGPoint(x:W*0.8,y:W/2), controlPoint: c.position())
        return path.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
