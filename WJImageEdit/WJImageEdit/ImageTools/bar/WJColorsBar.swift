//
//  WJColorsBar.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/7.
//  Copyright © 2018年 Roo. All rights reserved.
/**
 *  宽度 (colorList.count - 1) * 50 + 16 = 266
 *  高度 16
 */

import UIKit

class WJColorsBar: UIView {

    let colorList = [UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                     UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
                     UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1.0),
                     UIColor(red: 1.0, green: 0.2, blue: 0.60, alpha: 1.0),
                     UIColor(red: 0.20, green: 0.60, blue: 0.30, alpha: 1.0),
                     UIColor(red: 0.53, green: 0.24, blue: 0.85, alpha: 1.0),]
    
    var selectedColor:((UIColor) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        for i in 0..<colorList.count {
            let btn = UIButton(frame: CGRect(x: i * 50, y: 0, width: 16, height: 16))
            btn.backgroundColor = colorList[i]
            btn.layer.cornerRadius = 8
            btn.layer.masksToBounds = true
            btn.tag = i + 1000
            btn.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
            self.addSubview(btn)
        }
    }
    
    @objc func selectColor(_ sender: UIButton) {
        let index = sender.tag - 1000
        selectedColor?(colorList[index])
    }
    
}
