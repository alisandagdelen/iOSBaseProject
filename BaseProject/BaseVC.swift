//
//  BaseVC.swift
//  BaseProject
//
//  Created by alişan dağdelen on 11.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import UIKit


enum ShowType {
    case push
    case present
}

class BaseVC: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - VC methods
    
    func showVC(vc:BaseVC, showType:ShowType = .push, animated:Bool = true) {
        if let nav = navigationController, showType == .push {
            if let topVC = nav.topViewController, topVC == self {
                nav.pushViewController(vc, animated:animated)
            }
        }
        else {
            if presentedViewController == nil {
                present(vc, animated:animated, completion:nil)
            }
        }
    }
    
    func prepareVC(type:BaseVC.Type) -> BaseVC {
        let identifier:String = "\(type)"
        
        let vc = storyboard!.instantiateViewController(withIdentifier:identifier) as! BaseVC
        return vc
    }
    
    func navigationVC(name:String) -> UINavigationController {
        
        let vc = storyboard!.instantiateViewController(withIdentifier:name) as! UINavigationController
        
        return vc
    }
    
    func hideVC(animated:Bool = true, completion:(() -> Void)? = nil) {
        if let nav = navigationController{
            nav.popViewController(animated:animated)
            nav.delegate = self
        }
        else {
            dismiss(animated:animated, completion:completion)
        }
    }
    
}


extension BaseVC:UIPopoverPresentationControllerDelegate {
    
    class func showPopover(_ contentVC:UIViewController, sourceView:UIView, sourceRect:CGRect=CGRect.zero, contentSize:CGSize=CGSize.zero,  animated:Bool=true) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            contentVC.modalPresentationStyle = UIModalPresentationStyle.popover
            if contentSize != CGSize.zero {
                contentVC.preferredContentSize = contentSize
            }
            
            if let popover = contentVC.popoverPresentationController {
                popover.sourceView = sourceView
                var sr = sourceRect
                if sr == CGRect.zero {
                    let x = (sourceView.frame.size.width - contentVC.preferredContentSize.width) / 2.0
                    let y = (sourceView.frame.size.height - contentVC.preferredContentSize.height) / 2.0
                    sr = CGRect(x: x, y: y, width: contentVC.preferredContentSize.width, height: contentVC.preferredContentSize.height)
                }
                popover.sourceRect = sr

                popover.permittedArrowDirections = .any
            }
            rootVC.present(contentVC, animated:true) { }
        }
    }
    
    func showPopover(_ contentVC:UIViewController, sourceView:UIView, sourceRect:CGRect=CGRect.zero, contentSize:CGSize=CGSize.zero,  animated:Bool=true) {
        
        contentVC.modalPresentationStyle = UIModalPresentationStyle.popover
        if contentSize != CGSize.zero {
            contentVC.preferredContentSize = contentSize
        }
        
        if let popover = contentVC.popoverPresentationController {
            popover.sourceView = sourceView
            var sr = sourceRect
            if sr == CGRect.zero {
                let x = (sourceView.frame.size.width - contentVC.preferredContentSize.width) / 2.0
                let y = (sourceView.frame.size.height - contentVC.preferredContentSize.height) / 2.0
                sr = CGRect(x: x, y: y, width: contentVC.preferredContentSize.width, height: contentVC.preferredContentSize.height)
            }
            popover.sourceRect = sr
            popover.delegate = self
            popover.permittedArrowDirections = .any
            
        }
        present(contentVC, animated:true) { }
    }
    
    func dismissPopover() {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.dismiss(animated: true, completion:nil)
        }
    }
    
}
