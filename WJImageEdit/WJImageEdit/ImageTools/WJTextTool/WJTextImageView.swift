//
//  WJTextImageView.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/7.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

class WJTextImageView: UIImageView {

    var panRecongnizer:((CGPoint, UIPanGestureRecognizer, Bool) -> Void)?
    
    var pinchRecongnizer:((CGFloat, CGPoint, Int,Bool) -> Void)?
    
    var rotationRecongnizer:((CGFloat) -> Void)?
    
    var began_point:CGPoint!
    
    override init(image: UIImage?) {
        super.init(image: image)
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addGesture() {
        /// 拖动
        let pan = UIPanGestureRecognizer(target:self,action:#selector(panDid(_:)))
        pan.maximumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
        
//        /// 旋转
//        let rotation = UIRotationGestureRecognizer(target:self,
//                                                   action:#selector(rotationDid(_:)))
//        self.addGestureRecognizer(rotation)
//
//        // 捏合
//        let pinch = UIPinchGestureRecognizer(target:self,action:#selector(pinchDid(_:)))
//        self.addGestureRecognizer(pinch)
    }
    
    @objc func panDid(_ recognizer: UIPanGestureRecognizer){
        let point=recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            began_point = recognizer.location(in: self)
        
        default:
            panRecongnizer?(CGPoint(x: point.x - began_point.x, y: point.y - began_point.y),recognizer, recognizer.state == .ended)
        }
    }
    
    @objc func pinchDid(_ recognizer:UIPinchGestureRecognizer) {
        //在监听方法中可以实时获得捏合的比例
        let scale = recognizer.scale
        if recognizer.numberOfTouches == 2 {
            
            let p1 = recognizer.location(ofTouch: 0, in: self)
            let p2 = recognizer.location(ofTouch: 1, in: self)
            let p = CGPoint(x: (p1.x + p2.x)/2, y: (p1.y + p2.y)/2)
            pinchRecongnizer?(scale, p, 2, recognizer.state == .ended)
        }else {
            pinchRecongnizer?(scale, CGPoint(x: 0, y: 0), 1, recognizer.state == .ended)
        }
    }
    
    @objc func rotationDid(_ recognizer:UIRotationGestureRecognizer){
        //旋转的弧度转换为角度
//        print("旋转角度")
//        print(recognizer.rotation*(180/CGFloat.pi))
    }

}
