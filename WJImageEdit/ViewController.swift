//
//  ViewController.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/5.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var originalImage:UIImage = #imageLiteral(resourceName: "example_image")
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = originalImage
    }
    
    @IBAction func editImage(_ sender: Any) {
        let editor = WJImageEditorViewController(originalImage: originalImage)
        editor.sendImage = { [weak self](image) in
            self?.imageView.image = image
            self?.originalImage = image
        }
        self.navigationController?.pushViewController(editor, animated: true)
    }
    
}


