//
//  ETNavBarTransparent.swift
//  ETNavBarTransparentDemo
//
//  Created by Bing on 2017/3/1.
//  Copyright © 2017年 tanyunbing. All rights reserved.
//

import UIKit

extension UIColor {
    //System default bar tint color
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
            
            let needSwizzleSelectorArr = [["ori":NSSelectorFromString("_updateInteractiveTransition:"),"swi":NSSelectorFromString("et_updateInteractiveTransition:")],
                ["ori":#selector(popToViewController(_:animated:)),"swi":#selector(et_popToViewController(_:animated:))],
                ["ori":#selector(popToRootViewController(animated:)),"swi":#selector(et_popToRootViewController(animated:))]]
            
            for needSwizzleSelector in needSwizzleSelectorArr {
                let originalSelector = needSwizzleSelector["ori"]
                let swizzledSelector = needSwizzleSelector["swi"]
                let originalMethod = class_getInstanceMethod(self.classForCoder(), originalSelector)
                let swizzledMethod = class_getInstanceMethod(self.classForCoder(), swizzledSelector)
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
            
        }
        
    }
    

    func et_updateInteractiveTransition(_ percentComplete: CGFloat) {
        et_updateInteractiveTransition(percentComplete)
        if let topVC = self.topViewController {
            if let coor = topVC.transitionCoordinator {
                //Bg Alpha
                let fromAlpha = coor.viewController(forKey: .from)?.navBarBgAlpha
                let toAlpha = coor.viewController(forKey: .to)?.navBarBgAlpha
                let nowAlpha = fromAlpha! + (toAlpha!-fromAlpha!)*percentComplete
                
                self.setNeedsNavigationBackground(alpha: nowAlpha)
                
                //tintColor
                let fromColor = coor.viewController(forKey: .from)?.navBarTintColor
                let toColor = coor.viewController(forKey: .to)?.navBarTintColor
                let nowColor = averageColor(fromColor: fromColor!, toColor: toColor!, percent: percentComplete)
                self.navigationBar.tintColor = nowColor
            }
        }
    }
    
    //Calculate the middle Color with translation percent
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
    
    
    func et_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        setNeedsNavigationBackground(alpha: (viewController.navBarBgAlpha))
        navigationBar.tintColor = viewController.navBarTintColor
        return et_popToViewController(viewController, animated: animated)
    }
    
    func et_popToRootViewController(animated: Bool) -> [UIViewController]? {
        setNeedsNavigationBackground(alpha: (viewControllers.first?.navBarBgAlpha)!)
        navigationBar.tintColor = viewControllers.first?.navBarTintColor
        return et_popToRootViewController(animated: animated)
    }
    
    
    fileprivate func setNeedsNavigationBackground(alpha:CGFloat) {

        
        let barBackgroundView = navigationBar.subviews[0]
        if let shadowView = barBackgroundView.value(forKey: "_shadowView") as? UIView {
            shadowView.alpha = alpha
        }
        
        if navigationBar.isTranslucent {
            if #available(iOS 10.0, *){
                if navigationBar.backgroundImage(for: .default) == nil {
                    if let backgroundEffectView = barBackgroundView.value(forKey: "_backgroundEffectView") as? UIView {
                        backgroundEffectView.alpha = alpha
                        return
                    }
                }

            }else{
                if let adaptiveBackdrop = barBackgroundView.value(forKey: "_adaptiveBackdrop") as? UIView {
                    if let backdropEffectView = adaptiveBackdrop.value(forKey: "_backdropEffectView") as? UIView {
                        backdropEffectView.alpha = alpha
                        return
                    }
                }
            }
            

        }
        
        barBackgroundView.alpha = alpha
        
    }
    
    
}

extension UINavigationController:UINavigationControllerDelegate,UINavigationBarDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let topVC = navigationController.topViewController {
            if let coor = topVC.transitionCoordinator {
                if #available(iOS 10.0, *) {
                    coor.notifyWhenInteractionChanges({ (context) in
                        self.dealInteractionChanges(context)
                    })
                } else {
                    coor.notifyWhenInteractionEnds({ (context) in
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
        if let topVC = topViewController {
            if let coor = topVC.transitionCoordinator {
                if coor.initiallyInteractive {
                    return true
                }
            }
        }
        
        
        var popToVC: UIViewController?
        if viewControllers.count >= (navigationBar.items?.count)! {
            popToVC = viewControllers[viewControllers.count-2]
        }else{
            popToVC = viewControllers[viewControllers.count-1]
        }
        
        if popToVC != nil {
            _ = self.popToViewController(popToVC!, animated: true)
            return true
        }
        
        return false
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
            
            //Update UI
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
