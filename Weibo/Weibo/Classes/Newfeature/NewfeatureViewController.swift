//
//  NewfeatureViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/21.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit
private let reuseIdentifier = "Cell"
class NewfeatureViewController: UICollectionViewController {

    private let imageCount = 4
    private let layout = FlowLayout()
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        collectionView?.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
        
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
        cell.imageIndex = indexPath.item;
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems().last!
         print(path)
        if path.item == (imageCount - 1) {
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            cell.startBtnAnimation()
        }
        
    }
    
   
    
}




class NewfeatureCell: UICollectionViewCell {
    
    private var imageIndex: Int = 0 {
        didSet {
           iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            
        }
    }
    
    func startBtnAnimation() {
        if imageIndex == 3 {
            startButton.hidden = false
            
            //执行动画
            startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
            startButton.userInteractionEnabled = false
            UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.startButton.transform = CGAffineTransformIdentity
                }, completion: { (_) in
                    self.startButton.userInteractionEnabled = true
                    
            })
        }

    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startBtnClick() {
        print(#function)
        
        NSNotificationCenter.defaultCenter().postNotificationName(XMGRootViewControllerSwitchNotification, object: true, userInfo: nil)
    }
    
    
    private func setupUI()
    {
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)

        iconView.xmg_Fill(contentView)
        startButton.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size:nil, offset: CGPoint(x: 0, y: -160))
    }
    
    
  
    private lazy var iconView = UIImageView()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.hidden = true
        
        btn.addTarget(self, action: #selector(NewfeatureCell.startBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    
}




//自定义流水布局
private class FlowLayout:UICollectionViewFlowLayout {
    
    private override func prepareLayout() {
        itemSize = (collectionView?.bounds.size)!
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
}
