//
//  WJTextView.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/7.
//  Copyright © 2018年 Roo. All rights reserved.
//
import Foundation
import UIKit

class WJTextView: UIView {

    
    var colorbar: WJColorsBar!
    var textView: UITextView!
    var nav: WJNavShadeView!
    
    let textFont = UIFont(name: "PingFangSC-Regular", size: 20)
    var currentColor: UIColor! = UIColor.white
    
    var textImage: UIImage!
    
    var completeEditText:((WJTextModel) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
        addNotification()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
       
        self.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.85)
        
        nav = WJNavShadeView(frame: CGRect(x: 0, y: 0, width: self.width, height: wj_nav_h))
        nav.onpressCancel = cancelAction
        nav.onpressComplete = saveAction
        nav.backgroundColor = UIColor.black
        self.addSubview(nav)
        
        textView = UITextView(frame: CGRect(x: 20, y: nav.height, width: self.width - 40, height: 300))
        textView.textColor = .white
        textView.backgroundColor = UIColor.clear
        textView.font = textFont
        self.addSubview(textView)
        
        colorbar = WJColorsBar(frame: CGRect(x: (self.width - 266)/2, y: self.height - 16, width: 266, height: 16))
        colorbar.selectedColor = { [weak self](color) in
            self?.currentColor = color
            self?.textView.textColor = color
        }
        self.addSubview(colorbar)
        
    }
    
    
    
    //  MARK: - Action
    func cancelAction() {
        selfDismiss()
    }
    func saveAction() {
        if textView.text.count > 0, let image = buildImage(){
            let size = textView.text.sizeWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 40, font: textFont!)
            completeEditText?(WJTextModel(text: textView.text, image: image, color: currentColor, size: size))
        }
        selfDismiss()
    }
    
    func selfDismiss() {
        nav.isHidden = true
        textView.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            let h = UIScreen.main.bounds.size.height
            
            self.frame = CGRect(x: 0, y: h, width: self.width, height: h)
            
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
    
    /// 监听键盘
    private func addNotification() {
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    //当键盘出现或改变时调用
    @objc func keyboardWillChange(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt{
            
            let frame = value.cgRectValue
            UIView.animate(withDuration: duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve),
                                       animations: {
                                      self.colorbar.frame = CGRect(x: (self.width - 266)/2, y: self.height - frame.height - 26, width: self.width, height: 16)
                                        
            }, completion: nil)
        }
    }
    

    /// 生成图片
    
    func buildImage() -> UIImage? {
        let size = textView.text.sizeWithConstrainedWidth(width: UIScreen.main.bounds.size.width - 40, font: textFont!)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.backgroundColor?.setFill()
        
        //保存初始状态
        context.saveGState()
        
        //将坐标系系上下翻转
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        context.setStrokeColor(currentColor.cgColor)
        //创建并设置路径(排版区域)
        let path = CGMutablePath()
        //绘制椭圆
        path.addRect(rect)
//        绘制边框
//        context.addPath(path)
//        context.strokePath()
        //根据framesetter和绘图区域创建CTFrame
        let str = textView.text
        let attributes = [NSAttributedStringKey.font: textFont!, NSAttributedStringKey.foregroundColor: currentColor ] as [NSAttributedStringKey : Any]
        let attrString = NSAttributedString(string:str!, attributes: attributes)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length),
                                             path, nil)
        
        //使用CTFrameDraw进行绘制
        CTFrameDraw(frame, context)
        
        //恢复成初始状态
        context.restoreGState()
        
        textImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return textImage
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


struct WJTextModel {
    var text: String?
    var image: UIImage?
    var color: UIColor?
    var size: CGSize?
}
