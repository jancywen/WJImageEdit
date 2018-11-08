//
//  WJImageEditorViewController.swift
//  WJImageEdit
//
//  Created by wangwenjie on 2018/11/6.
//  Copyright © 2018年 Roo. All rights reserved.
//

import UIKit

class WJImageEditorViewController: UIViewController {

    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var menuView: ImageToolsBar!
    var navShadeView: WJNavShadeView!
    var originalImage:UIImage!
    
    /// 新画的图片
    lazy var compoundImageList = [UIImage]()
    
    /// 矩形工具
    var rectTool: WJRectTool!
    
    /// 文本工具
    var textTool: WJTextTool!
    
    var sendImage: ((UIImage) -> Void)?
    
    init(originalImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.originalImage = originalImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.automaticallyAdjustsScrollViewInsets = false
        
        initMenuView()
        initNavShadeView()
        initImageScrollView()
        
        if imageView == nil {
            imageView = UIImageView()
            scrollView.addSubview(imageView)
            refreshImageView()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshImageView()
    }
    
    //底部工具view
    func initMenuView() {
        if menuView == nil {
            menuView = ImageToolsBar(frame: CGRect(x: 0, y: view.height - 50, width: view.width, height: 50))
            menuView.backgroundColor = .black
            menuView.alpha = 0.7
            menuView.configImageBar(.edit)
            menuView.onpressEdit = editImage
            menuView.onpressSend = sendImageAction
            menuView.onpressRect = drawRect
            menuView.onpressText = drawText
            menuView.onpressDele = deleText
            menuView.onpressRevoke = revokeEdit
            view.addSubview(menuView)
        }
    }
    //底层ScrollView
    func initImageScrollView() {
        if scrollView == nil {
            let imageScroll = UIScrollView(frame: view.bounds)
            imageScroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            imageScroll.showsHorizontalScrollIndicator = false
            imageScroll.showsVerticalScrollIndicator = false
            imageScroll.delegate = self
            imageScroll.clipsToBounds = false
//            let y = navigationController?.navigationBar.bottom
//            imageScroll.top = y!
//            imageScroll.height = view.height - imageScroll.top - menuView.height
            imageScroll.top = 0
            imageScroll.height = self.view.height
            view.insertSubview(imageScroll, at: 0)
            scrollView = imageScroll
        }
    }
    // 导航栏遮罩
    func initNavShadeView() {
        if navShadeView == nil {
            let shade = WJNavShadeView(frame: CGRect(x: 0, y: 0, width: view.width, height: wj_nav_h))
            shade.backgroundColor = .black
            shade.alpha = 0.7
            shade.isHidden = true
            shade.onpressCancel = cancelEdit
            shade.onpressComplete = completeEdit
            self.view.addSubview(shade)
            navShadeView = shade
        }
    }
    
    
    func refreshImageView() {
        imageView.image = originalImage
        self.resetImageViewFrame()
        self.resetZoomScaleWith(animated: false)
    }
    
    func resetImageViewFrame() {
        let size: CGSize = imageView.image != nil ? imageView.image!.size : imageView.frame.size
        if size.width > 0 && size.height > 0 {
            let ratio: CGFloat = min(scrollView.frame.size.width / size.width, scrollView.frame.size.height / size.height)
            let W: CGFloat = ratio * size.width * scrollView.zoomScale
            let H: CGFloat = ratio * size.height * scrollView.zoomScale
            imageView.frame = CGRect(x: max(0, (scrollView.width - W) / 2), y: max(0, (scrollView.height - H) / 2), width: W, height: H)
        }
    }
    
    func resetZoomScaleWith(animated: Bool) {
        var Rw: CGFloat = scrollView.frame.size.width / imageView.frame.size.width
        var Rh: CGFloat = scrollView.frame.size.height / imageView.frame.size.height
        //CGFloat scale = [[UIScreen mainScreen] scale];
        let scale: CGFloat = 1
        Rw = max(Rw, imageView.image!.size.width / (scale * scrollView.frame.size.width))
        Rh = max(Rh, imageView.image!.size.height / (scale * scrollView.frame.size.height))
        scrollView.contentSize = imageView.frame.size
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = max(max(Rw, Rh), 1)
//                scrollView.maximumZoomScale = 5
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: animated)
    }
    
    func updateNavBar(_ editing: Bool) {
        self.navigationController?.isNavigationBarHidden = editing
        navShadeView.isHidden = !editing
        menuView.configImageBar(editing ? .editing : .edit)
    }
    
    
    //  MARK: - ACTION
    /// 编辑
    func editImage() {
        updateNavBar(true)
    }
    /// 发送
    func sendImageAction() {
        sendImage?(originalImage)
        navigationController?.popViewController(animated: true)
    }
    /// 矩形
    func drawRect() {
        
        for sub in imageView.subviews {
            if sub.isKind(of: WJTextImageView.self) {
                break
            }
            sub.removeFromSuperview()
        }
        
        if rectTool == nil {
            rectTool = WJRectTool(self)
        }
        rectTool.setup()
    }
    /// 文本
    func drawText() {
        if textTool == nil {
            textTool = WJTextTool(self)
        }
        textTool.addText()
        
    }
    /// 撤销
    func revokeEdit() {
        if compoundImageList.count > 0 {
            compoundImageList.removeLast()
            imageView.image = compoundImageList.first ?? originalImage
        }
    }
    /// 删除文本
    func deleText() {
        
    }
    
    /// 取消编辑
    func cancelEdit() {
        updateNavBar(false)
        imageView.image = originalImage
        compoundImageList.removeAll()
    }
    /// 完成编辑
    func completeEdit() {
        updateNavBar(false)
        imageView.image = compoundImageList.last ?? originalImage
        originalImage = compoundImageList.last ?? originalImage
        compoundImageList.removeAll()
        
        
        let originalImageSize: CGSize! = self.imageView.image?.size
        UIGraphicsBeginImageContextWithOptions(originalImageSize, false, imageView?.image?.scale ?? 0.0)
        imageView?.image?.draw(at: CGPoint.zero)
        for sub in imageView.subviews {
            if let sub_imv = sub as? WJTextImageView {
                sub_imv.image!.draw(in: sub_imv.frame)
            }
        }
//        drawingView.image!.draw(in: CGRect(x: 0, y: 0, width: originalImageSize.width, height: originalImageSize.height))
        let tmp: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = tmp
        
        originalImage = tmp
        for sub in imageView.subviews {
            sub.removeFromSuperview()
        }
        
    }
}

extension WJImageEditorViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let Ws: CGFloat = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right
        let Hs: CGFloat = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let W: CGFloat = imageView.frame.size.width
        let H: CGFloat = imageView.frame.size.height
        var rct: CGRect = imageView.frame
        rct.origin.x = max((Ws - W) / 2, 0)
        rct.origin.y = max((Hs - H) / 2, 0)
        imageView.frame = rct
    }
}
