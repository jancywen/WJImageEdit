//
//  WJTextTool.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

class WJTextTool: NSObject {
    var editor: WJImageEditorViewController!
    
    init(_ editor: WJImageEditorViewController) {
        super.init()
        self.editor = editor
    }
        
    func addText() {
        let textView = WJTextView(frame: CGRect(x: 0, y: self.editor.view.height, width: self.editor.view.width, height: self.editor.view.height))
        self.editor.view.addSubview(textView)
        textView.textView.becomeFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
            textView.frame = CGRect(x: 0, y: 0, width: self.editor.view.width, height: self.editor.view.height)
        }) { (com) in
            
        }
        
        textView.completeEditText = {(model) in
            self.editor.imageView.isUserInteractionEnabled = true
            
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: model.size!)
            let imv = WJTextImageView(image: model.image)
            imv.bounds = rect
            imv.isUserInteractionEnabled = true
            imv.center = CGPoint(x: self.editor.imageView.width/2, y: self.editor.imageView.height/2)
            self.editor.imageView.addSubview(imv)
            
            imv.panRecongnizer = { (point, recognizer, end) in
                let center = imv.frame.origin
                imv.frame.origin = CGPoint(x: center.x + point.x, y: center.y + point.y)
                
                self.editor.menuView.configImageBar(end ? .editing : .dele )
                
                let touch_point = recognizer.location(in: self.editor.view)
                let m_left = self.editor.view.width / 2 - 40
                let m_right = self.editor.view.width / 2 + 40
                let m_top = self.editor.view.height - 100
                
                if touch_point.x > m_left && touch_point.x < m_right && touch_point.y > m_top {
                    self.editor.menuView.backgroundColor = end ? .black : .clear
                    if end {
                        imv.removeFromSuperview()
                    }
                }else {
                    self.editor.menuView.backgroundColor = .black
                }
            }
            
            imv.pinchRecongnizer = {(scale,p1, num, end) in
                imv.transform = CGAffineTransform(scaleX: scale, y: scale)
                if end && num == 2{
//                    imv.transform = CGAffineTransform(scaleX: 1, y: 1)
                    let size = imv.frame.size
                    let center = imv.center
                    imv.frame.size = CGSize(width: size.width * scale, height: size.height * scale)
                    
                    let s_x = abs(p1.x - center.x)
                    let s_y = abs(p1.y - center.y)
                    let incre_x = (scale - 1) * s_x
                    let incre_y = (scale - 1) * s_y
                    
                    imv.center = CGPoint(x: center.x + incre_x, y: center.y + incre_y)
                }
            }
        }
    }
}
