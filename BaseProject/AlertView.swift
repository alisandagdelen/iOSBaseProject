//
//  AlertView.swift
//  BaseProject
//
//  Created by alişan dağdelen on 30.07.2017.
//  Copyright © 2017 alisandagdeleb. All rights reserved.
//

import Foundation
import SCLAlertView

enum AlertViewType {
    case success, error, notice, warning, info, edit(text:String), wait, dialog
}

enum AlertButtonType{
    case cancel, destructive, apply, normal
}

class AlertView {
    
    private static var currentAlertView:SCLAlertView?
    static var currentTextfield:UITextField?
    static var currentSubmitButton:UIButton?
    
    class func dismiss() {
        if let alertView = currentAlertView, alertView.view.superview != nil {
            alertView.hideView()
        }
    }
    
    class func show(_ title:String?=nil) {
        show(.wait, title:title ?? "")
    }
    
    class func show(_ type:AlertViewType = .wait, _ title:String?=nil) {
        show(type, title:title ?? "")
    }
    
    
    class func show(_ type:AlertViewType, title:String, subTitle:String?=nil, showCloseButton:Bool=false, duration:TimeInterval=2) {
        
        currentTextfield = nil
        
        //        var animationStyle = SCLAnimationStyle.topToBottom
        var animationStyle = SCLAnimationStyle.noAnimation
        if let alertView = currentAlertView, alertView.view.superview != nil {
            alertView.hideView()
            animationStyle = .noAnimation
        }
        
        var hideWhenBackgroundViewIsTapped = true
        var duration:TimeInterval = duration
        var showCircularIcon:Bool = true
        
        if showCloseButton {
            hideWhenBackgroundViewIsTapped = false
            duration = 0
        }
        var alertTitle = title
        var alertSubTitle:String = subTitle ?? ""
        
        switch type {
        case .wait:
            hideWhenBackgroundViewIsTapped = false
            if alertSubTitle.isEmpty {
                alertSubTitle = "Please wait."
            }
        case .dialog:
            showCircularIcon = false
        case .success:
            if alertTitle.isEmpty {
                alertTitle = "Successful "
            }
        case .error:
            if alertTitle.isEmpty {
                alertTitle = "Operation Failed!"
            }
        case .edit(_), .info:
            hideWhenBackgroundViewIsTapped = false
            
        default:
            break
        }
        
        
        let appearance = SCLAlertView.SCLAppearance(
            kDefaultShadowOpacity:0.1,
            kWindowWidth:300,
            kWindowHeight:200,
            kTitleFont:UIFont.systemFont(ofSize:18),
            showCloseButton:showCloseButton,
            showCircularIcon:showCircularIcon,
            hideWhenBackgroundViewIsTapped:hideWhenBackgroundViewIsTapped
        )
        let alertView = SCLAlertView(appearance:appearance)
        
        
        let closeButtonTitle:String? = showCloseButton ? "Ok" : nil
        
        DispatchQueue.main.async {
            switch type {
            case .success:
                alertView.showSuccess(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:1, animationStyle:animationStyle)
            case .error:
                alertView.showError(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:duration, animationStyle:animationStyle)
            case .notice:
                alertView.showNotice(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:duration, animationStyle:animationStyle)
            case .warning:
                alertView.showWarning(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:duration, animationStyle:animationStyle)
            case .info:
                alertView.showInfo(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:duration, animationStyle:animationStyle)
            case .edit(let text):
                currentTextfield = alertView.addTextField("")
                currentTextfield?.text = text
                if let _ = currentSubmitButton {
                    currentTextfield?.addTarget(currentAlertView, action: #selector(SCLAlertView.textFieldDidChange(_:)), for:.editingChanged)
                }
                alertView.showEdit(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:0, animationStyle:animationStyle)
            case .wait:
                alertView.showWait(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:0, animationStyle:animationStyle)
            case .dialog:
                alertView.showInfo(alertTitle, subTitle:alertSubTitle, closeButtonTitle:closeButtonTitle, duration:0, circleIconImage : nil, animationStyle:animationStyle)
            }
        }
        currentAlertView = alertView
    }
    
    
    class func addButton(title:String, type:AlertButtonType = .normal, checkTextfield:Bool=false, action:@escaping ()->Void) {
        var backgroundColor:UIColor?
        switch type {
        case .cancel:
            backgroundColor = UIColorFromRGB(0x808080)
        case .normal:
            backgroundColor = nil
        case .apply:
            backgroundColor = UIColorFromRGB(0x22B573)
        case .destructive:
            backgroundColor = UIColorFromRGB(0xC1272D)
            
        }
        
        let button = currentAlertView?.addButton(title, backgroundColor:backgroundColor, action:action)
        if checkTextfield {
            currentSubmitButton = button
            currentSubmitButton?.isEnabled = false
        }
        
    }
    
}


extension SCLAlertView {
    
    func textFieldDidChange(_ sender:UITextField) {
        if let text = sender.text, !text.isEmpty && !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            AlertView.currentSubmitButton?.isEnabled = true
        }
        else {
            AlertView.currentSubmitButton?.isEnabled = false
        }
    }
}



func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
