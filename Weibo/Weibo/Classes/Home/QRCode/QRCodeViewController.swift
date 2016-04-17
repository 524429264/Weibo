//
//  QRCodeViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/17.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit
import AVFoundation;
class QRCodeViewController: UIViewController{

    //扫描容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
   //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    //冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    @IBOutlet weak var customTabBar: UITabBar!

    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //监听名片按钮点击
    @IBAction func myCardBtnClick(sender: AnyObject) {
        
        let qrCard = QRCodeCardViewController()
        navigationController?.pushViewController(qrCard, animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
        //1.开启冲击波动画
        startAnimation()
        //2.开始扫描
        startScan()
        
    }
    
    private func startScan() {
        //关联输入输出对象
        // 1.判断能否添加输入设备
        if !session.canAddInput(deviceInput) {
            return
        }
        
        //2.判断能否添加输出对象
        if !session.canAddOutput(output) {
            return
        }
        
        //3.添加输入输出对象
        session.addInput(deviceInput)
        print(output.metadataObjectTypes)
        session.addOutput(output)
        print(output.metadataObjectTypes)
        
        // 设置输出对象能够解析的类型必须在输出对象添加到会话之后设置, 否则会报错
        // 4.告诉输出对象, 需要输出什么样的数据(支持解析🐴类型数据)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5.设置代理坚挺输出对象输出的数据
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        output.rectOfInterest = CGRectMake(0, 0, 0.5, 0.5)
        
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        previewLayer.addSublayer(drawLayer)
       
        // 7.开始扫描
        session.startRunning()
        
    }
    

    
    private func startAnimation(){
        
        // 1.重新设置冲击波顶部约束
        // 一定要加上这一句, 否则会混乱
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(2.0) { 
            // 0.设置动画重复次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // 1.修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
            // 2.执行动画
            self.view.layoutIfNeeded()
        }

    }
    

    // MARK: - 懒加载
    
    //创建桥梁
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 2.获取输入设备(摄像头)
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
       
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch
        {
            print(error)
            return nil
        }
    }()
    
    //获取输出对象
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    

    //创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        // 3.设置填充模式, 否则4s会有问题
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return layer
    }()
    
    //创建边框图层
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        
        return layer
    }()
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate, UITabBarDelegate
{
    // MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1 {
            print("二维码")
            self.containerHeightCons.constant = 300
        }else
        {
            print("条形码")
            self.containerHeightCons.constant = 150
        }
        
        self.scanLineView.layer.removeAllAnimations()
        startAnimation()
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        print(metadataObjects.last?.stringValue)
        
         // 0.移除边线
        clearDrawLayer()
        //1.绘制路径
        for object in metadataObjects  {
            if object is AVMetadataMachineReadableCodeObject  {
                //转换元数据对象坐标
              let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                drawCorners(codeObject)
                
            }
        }
    }
    
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject)
    {
        //1.判断数组是否为空
        if codeObject.corners.isEmpty {
            return
        }
        //2.创建图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.greenColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        //3.绘制图形
        layer.path = cornersPath(codeObject.corners)
        
        //4.添加图层
        drawLayer.addSublayer(layer)
    }
    
    private func cornersPath(corners: NSArray) ->CGPath {
        
        let path = UIBezierPath()
        var point = CGPointZero
        var index = 0
        
        CGPointMakeWithDictionaryRepresentation(corners[index] as! CFDictionaryRef, &point)
        path.moveToPoint(point)
        
        while index < corners.count
        {
            CGPointMakeWithDictionaryRepresentation(corners[index++] as! CFDictionaryRef, &point)

            path.addLineToPoint(point)
        }
        
        path.closePath()
        return path.CGPath
    }
    
    private func clearDrawLayer() {
        
        // 1.判断是否有边线
        if drawLayer.sublayers?.count == 0 || drawLayer.sublayers == nil {
            return
        }
        
        // 2.移除所有边线
        for layer in drawLayer.sublayers! {
            layer.removeFromSuperlayer()
        }
    }
}
