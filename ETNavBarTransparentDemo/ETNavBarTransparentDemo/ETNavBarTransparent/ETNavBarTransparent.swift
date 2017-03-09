//
//  ETNavBarTransparent.swift
//  ETNavBarTransparentDemo
//
//  Created by Bing on 2017/3/1.
//  Copyright © 2017年 tanyunbing. All rights reserved.
//

import UIKit

extension UIColor {
    open class func defaultNavBarTintColor() -> UIColor {
        return UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1.0)
    }
    
}

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    open override class func initialize(){
        
        if self == UINavigationController.self {
            let originalSelectorArr = ["_updateInteractiveTransition:"]
            
            for ori in originalSelectorArr {
                let originalSelector = NSSelectorFromString(ori)
                let swizzledSelector = NSSelectorFromString("et_\(ori)")
                let originalMethod = class_getInstanceMethod(self.classForCoder(), originalSelector)
                let swizzledMethod = class_getInstanceMethod(self.classForCoder(), swizzledSelector)
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
            
        }
        
    }
    

    func et__updateInteractiveTransition(_ percentComplete: CGFloat) {
        et__updateInteractiveTransition(percentComplete)
        let topVC = self.topViewController
        if topVC != nil {
            let coor = topVC?.transitionCoordinator
            if coor != nil {
                //Bg Alpha
                let fromAlpha = coor?.viewController(forKey: .from)?.navBarBgAlpha
                let toAlpha = coor?.viewController(forKey: .to)?.navBarBgAlpha
                let nowAlpha = fromAlpha! + (toAlpha!-fromAlpha!)*percentComplete
                
                self.setNeedsNavigationBackground(alpha: nowAlpha)
                
                //tintColor
                let fromColor = coor?.viewController(forKey: .from)?.navBarTintColor
                let toColor = coor?.viewController(forKey: .to)?.navBarTintColor
                let nowColor = averageColor(fromColor: fromColor!, toColor: toColor!, percent: percentComplete)
                self.navigationBar.tintColor = nowColor
            }
        }
        
    }
    
    private func averageColor(fromColor:UIColor, toColor:UIColor, percent:CGFloat) -> UIColor {
        var fromRed :CGFloat = 0.0
        var fromGreen :CGFloat = 0.0
        var fromBlue :CGFloat = 0.0
        var fromAlpha :CGFloat = 0.0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed :CGFloat = 0.0
        var toGreen :CGFloat = 0.0
        var toBlue :CGFloat = 0.0
        var toAlpha :CGFloat = 0.0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed-fromRed)*percent
        let nowGreen = fromGreen + (toGreen-fromGreen)*percent
        let nowBlue = fromBlue + (toBlue-fromBlue)*percent
        let nowAlpha = fromAlpha + (toAlpha-fromAlpha)*percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
    fileprivate func setNeedsNavigationBackground(alpha:CGFloat) {
        let barBackgroundView = navigationBar.value(forKey: "_barBackgroundView") as AnyObject
        let backgroundEffectView = barBackgroundView.value(forKey: "_backgroundEffectView") as! UIVisualEffectView
        let shadowView = barBackgroundView.value(forKey: "_shadowView") as! UIView
        backgroundEffectView.alpha = alpha
        shadowView.alpha = alpha
        
    }
    
    
}

extension UINavigationController:UINavigationControllerDelegate,UINavigationBarDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let topVC = navigationController.topViewController
        if topVC != nil {
            let coor = topVC?.transitionCoordinator
            if coor != nil {
                
                if #available(iOS 10.0, *) {
                    coor?.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                    })
                } else {
                    coor?.notifyWhenInteractionEnds({ (context) in
                        self.dealInteractionChanges(context)
                    })
                    
                } 

            }
            
        }
    }
    
    private func dealInteractionChanges(_ context:UIViewControllerTransitionCoordinatorContext) {
        if context.isCancelled {
            let cancellDuration:TimeInterval = context.transitionDuration * Double( context.percentComplete)
            UIView.animate(withDuration: cancellDuration, animations: {
                
                let nowAlpha = (context.viewController(forKey: .from)?.navBarBgAlpha)!
                self.setNeedsNavigationBackground(alpha: nowAlpha)
                
                self.navigationBar.tintColor = context.viewController(forKey: .from)?.navBarTintColor
            })
        }else{
            let finishDuration:TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration, animations: {
                let nowAlpha = (context.viewController(forKey: .to)?.navBarBgAlpha)!
                self.setNeedsNavigationBackground(alpha: nowAlpha)
                
                self.navigationBar.tintColor = context.viewController(forKey: .to)?.navBarTintColor
            })
        }
    }
    
    
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count >= (navigationBar.items?.count)! {
            let popToVC = viewControllers[viewControllers.count-2]
            setNeedsNavigationBackground(alpha: (popToVC.navBarBgAlpha))
            navigationBar.tintColor = popToVC.navBarTintColor
            
            _ = self.popViewController(animated: true)
        }
        
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        setNeedsNavigationBackground(alpha: (topViewController?.navBarBgAlpha)!)
        navigationBar.tintColor = topViewController?.navBarTintColor
        return true
    }
    
}




extension UIViewController {
    
    fileprivate struct AssociatedKeys {
        static var navBarBgAlpha: CGFloat = 1.0
        static var navBarTintColor: UIColor = UIColor.defaultNavBarTintColor()
    }
    
    open var navBarBgAlpha: CGFloat {
        get {
            let alpha = objc_getAssociatedObject(self, &AssociatedKeys.navBarBgAlpha) as? CGFloat
            if alpha == nil {
                return 1.0
            }else{
                return alpha!
            }
            
        }
        set {
            var alpha = newValue
            if alpha > 1 {
                alpha = 1
            }
            if alpha < 0 {
                alpha = 0
            }
            
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBgAlpha, alpha, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            //设置UI
            navigationController?.setNeedsNavigationBackground(alpha: alpha)
        }
    }
    
    open var navBarTintColor: UIColor {
        get {
            let tintColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarTintColor) as? UIColor
            if tintColor == nil {
                return UIColor.defaultNavBarTintColor()
            }else{
                return tintColor!
            }
            
        }
        set {
            navigationController?.navigationBar.tintColor = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.navBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
}
