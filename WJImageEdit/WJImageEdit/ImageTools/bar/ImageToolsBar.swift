//
//  ImageToolsBar.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

class ImageToolsBar: UIView {
    
    var onpressEdit: (() -> Void)?
    var onpressSend: (() -> Void)?
    var onpressRect: (() -> Void)?
    var onpressText: (() -> Void)?
    var onpressRevoke: (() -> Void)?
    var onpressDele:(() -> Void)?
    
    
    var editBar: ImageEditBar!
    var editingBar: ImageEditingBar!
    var deleBar: ImageDeleBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configEditBar()
        configEditingBar()
        configDeleBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 编辑/发送讨论
    private func configEditBar() {
        editBar = ImageEditBar(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        editBar.onpressEdit = { [weak self] in
            self?.onpressEdit?()
            self?.configImageBar(.editing)
        }
        editBar.onpressSend = {[weak self] in
            self?.onpressSend?()
        }
        self.addSubview(editBar)
    }
    /// 正在编辑
    private func configEditingBar() {
        editingBar = ImageEditingBar(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        editingBar.onpressRect = {[weak self] in
            self?.onpressRect?()
        }
        editingBar.onpressText = {[weak self] in
            self?.onpressText?()
        }
        editingBar.onpressRevoke = {[weak self] in
            self?.onpressRevoke?()
        }
        self.addSubview(editingBar)
    }
    /// 删除
    private func configDeleBar() {
        deleBar = ImageDeleBar(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        deleBar.onpressDele = {[weak self] in
            self?.onpressDele?()
        }
        self.addSubview(deleBar)
    }

    
    func configImageBar(_ type: ImageToolsBarType) {
        editBar.isHidden = type != .edit
        editingBar.isHidden = type != .editing
        deleBar.isHidden = type != .dele
    }
    
}


class ImageEditBar: UIView {
    
    var onpressEdit: (() -> Void)?
    var onpressSend: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        /// 编辑
        let edit = UIButton(frame: CGRect(x: 0, y: 0, width: edit_bar_edit_btn_w, height: edit_bar_edit_btn_h))
        edit.setTitle("编辑", for: .normal)
        edit.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        edit.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        self.addSubview(edit)
        
        let send = UIButton(frame: CGRect(x: self.width - edit_bar_send_btn_w, y: 0, width: edit_bar_send_btn_w, height: edit_bar_send_btn_h))
        send.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        send.setTitle("发送讨论", for: .normal)
        send.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        self.addSubview(send)
    }
    
    @objc private func editAction() {
        onpressEdit?()
    }
    @objc private func sendAction() {
        onpressSend?()
    }
}

class ImageEditingBar: UIView {
    
    
    var onpressRect: (() -> Void)?
    var onpressText: (() -> Void)?
    var onpressRevoke: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        let rect: UIButton = UIButton(frame: CGRect(x: self.width/2 - 1.5 * editing_bar_btn_w, y: 0, width: editing_bar_btn_w, height: editing_bar_btn_h))
        rect.setImage(#imageLiteral(resourceName: "wj_edit_rect"), for: .normal)
        rect.addTarget(self, action: #selector(rectAction), for: .touchUpInside)
        self.addSubview(rect)
        
        let text: UIButton = UIButton(frame: CGRect(x: self.width/2 - 0.5 * editing_bar_btn_w, y: 0, width: editing_bar_btn_w, height: editing_bar_btn_h))
        text.setImage(#imageLiteral(resourceName: "wj_edit_text"), for: .normal)
        text.addTarget(self, action: #selector(textAction), for: .touchUpInside)
        self.addSubview(text)
        
        let revoke: UIButton = UIButton(frame: CGRect(x: self.width/2 + 0.5 * editing_bar_btn_w, y: 0, width: editing_bar_btn_w, height: editing_bar_btn_h))
        revoke.setImage(#imageLiteral(resourceName: "wj_edit_revoke"), for: .normal)
        revoke.addTarget(self, action: #selector(revokeAction), for: .touchUpInside)
        self.addSubview(revoke)
    }
    
    @objc private func rectAction() {
        onpressRect?()
    }
    @objc private func textAction() {
        onpressText?()
    }
    @objc private func revokeAction() {
        onpressRevoke?()
    }
}

class ImageDeleBar: UIView {
    
    var onpressDele:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configView() {
        let dele: UIButton = UIButton(frame: CGRect(x: self.width/2 - 0.5 * editing_bar_btn_w, y: 0, width: editing_bar_btn_w, height: editing_bar_btn_h))
        dele.setImage(#imageLiteral(resourceName: "wj_edit_dele"), for: .normal)
        dele.addTarget(self, action: #selector(deleAction), for: .touchUpInside)
        self.addSubview(dele)
    }
    
    @objc private func deleAction() {
        onpressDele?()
    }
}
