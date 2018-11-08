//
//  String+extension.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/7.
//  Copyright © 2018年 Roo. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// 文本 size
    ///
    /// - Parameters:
    ///   - width: 默认宽度
    ///   - font: 字体
    /// - Returns: 返回文本高度
    func sizeWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size
        
        return boundingBox
    }
    
}
