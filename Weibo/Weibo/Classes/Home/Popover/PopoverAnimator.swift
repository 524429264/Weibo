//
//  PopoverAnimator.swift
//  Weibo
//
//  Created by nsky on 16/4/17.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

//定义常量 保存通知名称
let TYHPopooverAnimatorWillShow = "TYHPopooverAnimatorWillShow"
let TYHPopooverAnimatorWillDismiss = "TYHPopooverAnimatorWillDismiss"

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
{
    var isPresent: Bool = false
    var presentFrame = CGRectZero

    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    /**
     返回负责提供 Modal 动画对象
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        //f发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(TYHPopooverAnimatorWillShow, object: self)
        return self
    }
    
    /**
     返回负责 dismiss 动画对象
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(TYHPopooverAnimatorWillDismiss, object: self)
        return self
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        // UITransitionContextFromViewKey, and UITransitionContextToViewKey
        
        if isPresent {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            transitionContext.containerView()?.addSubview(toView!)
            
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0);
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toView?.transform = CGAffineTransformIdentity
                
                }, completion: { (Bool) in
                    transitionContext.completeTransition(true)
            })
        }else
        {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                
                fromView?.transform = CGAffineTransformMakeScale(1.0  , 0.000001)
                }, completion: { (Bool) in
                    fromView?.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
            
        }
    }
    
}