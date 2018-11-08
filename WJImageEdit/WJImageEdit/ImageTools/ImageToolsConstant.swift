//
//  ImageToolsConstant.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import Foundation
import UIKit


let edit_bar_h: CGFloat = 50
/// 编辑 w
let edit_bar_edit_btn_w: CGFloat = 50
/// 编辑 h
let edit_bar_edit_btn_h: CGFloat = 50
/// 发送讨论 w
let edit_bar_send_btn_w: CGFloat = 80
/// 发送讨论 h
let edit_bar_send_btn_h: CGFloat = 50


let editing_bar_h: CGFloat = 50

let editing_bar_btn_w: CGFloat = 50
let editing_bar_btn_h: CGFloat = 50

let dele_bar_h: CGFloat = 50


/// nav 高度
let wj_nav_h = UIApplication.shared.statusBarFrame.size.height + 44.0

let wj_nav_shade_btn_w: CGFloat = 50.0

/// bar类型
enum ImageToolsBarType {
    /// 编辑/发送讨论
    case edit
    /// 正在编辑
    case editing
    /// 删除
    case dele
}

/// 按钮类型
enum ImageToolsBarBtnType {
    /// 编辑
    case edit
    /// 发送
    case send
    /// 矩形
    case rect
    /// 文本
    case text
    /// 撤销
    case revoke
    /// 删除
    case dele
}
