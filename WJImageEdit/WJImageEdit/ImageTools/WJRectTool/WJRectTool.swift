//
//  WJRectTool.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

class WJRectTool: NSObject {
    
    var originalImageSize: CGSize!
    var drawingView: UIImageView!
    
    var editor: WJImageEditorViewController!
    
    var beganPoint: CGPoint!
    
    init(_ editor: WJImageEditorViewController) {
        super.init()
        self.editor = editor
    }
    
    func setup() {
        originalImageSize = editor.imageView?.image?.size
        drawingView = UIImageView(frame: editor.imageView?.bounds ?? CGRect.zero)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.drawingViewDidPan(_:)))
        panGesture.maximumNumberOfTouches = 1
        drawingView.isUserInteractionEnabled = true
        drawingView.addGestureRecognizer(panGesture)
        editor.imageView?.addSubview(drawingView)
        editor.imageView?.isUserInteractionEnabled = true
        editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        editor.scrollView.panGestureRecognizer.delaysTouchesBegan = false
        editor.scrollView.pinchGestureRecognizer?.delaysTouchesBegan = false
    }
    
    
    @objc func drawingViewDidPan(_ gesture: UIPanGestureRecognizer) {
        
        
        let currentDraggingPosition = gesture.location(in: drawingView)
        switch gesture.state {
        case .began:
            beganPoint = currentDraggingPosition
        case .ended:
            drawRect(from: beganPoint, to: currentDraggingPosition)
            ///
            if let newImage = buildImage() {
                editor.compoundImageList.append(newImage)
                editor.imageView.image = newImage
                drawingView.image = nil
            }
       default:
            drawRect(from: beganPoint, to: currentDraggingPosition)
        }
    }
    
    /// 画矩形
    private func drawRect(from: CGPoint, to: CGPoint) {
        
        let size: CGSize = drawingView.frame.size

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //创建一个矩形
        let drawingRect = CGRect(x: from.x, y: from.y, width: to.x - from.x, height: to.y - from.y)
        
        
        //创建并设置路径
        let path = CGMutablePath()
        //绘制矩形
        path.addRect(drawingRect)
        
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(UIColor.red.cgColor)
        //设置笔触宽度
        context.setLineWidth(2)
        
        //虚线每个线段的长度与间隔
        let lengths: [CGFloat] = [5,2]
        //设置虚线样式
        context.setLineDash(phase: 0, lengths: lengths)
        
        //画图
        context.drawPath(using: .stroke)
        
        drawingView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    func buildImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(originalImageSize, false, editor.imageView?.image?.scale ?? 0.0)
        editor.imageView?.image?.draw(at: CGPoint.zero)
        drawingView.image!.draw(in: CGRect(x: 0, y: 0, width: originalImageSize.width, height: originalImageSize.height))
        let tmp: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tmp
    }
}
