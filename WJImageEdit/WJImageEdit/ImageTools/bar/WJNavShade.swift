//
//  WJNavShade.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/6.
//  Copyright © 2018年 Roo. All rights reserved.
/**
 *  nav 遮罩
 *  取消, 完成
 */

import UIKit

class WJNavShadeView: UIView {

    var onpressCancel: (() -> Void)?
    var onpressComplete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
    /// 编辑
    let cancel = UIButton(frame: CGRect(x: 0, y: 0, width: wj_nav_shade_btn_w, height: wj_nav_h))
    cancel.setTitle("取消", for: .normal)
    cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    cancel.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
    self.addSubview(cancel)
    
    let complete = UIButton(frame: CGRect(x: self.width - wj_nav_shade_btn_w, y: 0, width: wj_nav_shade_btn_w, height: wj_nav_h))
    complete.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
    complete.setTitle("完成", for: .normal)
    complete.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
    self.addSubview(complete)
}

@objc private func cancelAction() {
    onpressCancel?()
}
@objc private func completeAction() {
    onpressComplete?()
}
}
