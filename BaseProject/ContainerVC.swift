//
//  ContainerVC.swift
//  BaseProject
//
//  Created by alişan dağdelen on 11.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import UIKit

enum ContainerAnimaton {
    case none
    case bottomToTop
    case growUp(from:CGRect)
}

class ContainerVC: BaseVC {
    
    var currentVC:UIViewController!
    var beginRect:CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
    }
    
    
    func showChildVC(_ vc:UIViewController, animation:ContainerAnimaton = .none) {
        
        if currentVC == nil {
            view.addSubview(vc.view)
        }
        else if currentVC != vc {
            transition(from: currentVC, to: vc, duration: 0, options: UIViewAnimationOptions(), animations: nil, completion:nil)
        }
        else {
            vc.view.removeFromSuperview()
            view.addSubview(vc.view)
        }
        
        
        switch animation {
        case .none:
            vc.view.frame = self.view.bounds
        case .bottomToTop:
            var frame = view.bounds
            frame.origin.y = frame.size.height
            vc.view.frame = frame
            vc.view.alpha = 0.5
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                vc.view.frame = self.view.bounds
                vc.view.alpha = 1
            })
        case .growUp(let from):
            beginRect = self.view.convert(from, from:nil)
            vc.view.frame = beginRect
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                vc.view.frame = self.view.bounds
            })
        }
        
        currentVC = vc
    }
    
    func prepareChildVC(_ vcClass:BaseVC.Type, withNavigationController hasNavController:Bool=false) -> UIViewController! {
        let vc = prepareVC(type: vcClass)
        vc.view.frame = view.bounds
        
        if hasNavController {
            let navController = UINavigationController(rootViewController:vc)
            navController.view.frame = view.bounds
            
            addChildViewController(navController)
            return navController
        }
        else {
            addChildViewController(vc)
            return vc
        }
        
    }
    
}
