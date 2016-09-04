//
//  LoginViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 1/22/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit
import KeyboardMan
import Ruler

import RxSwift
import RxCocoa

let minimalUserNameLength = 4
let minimalPasswordLength = 4

class LoginViewController: ViewController {

    var backgroundImageView: UIImageView?
    var contentView: UIView?
    var userNameTextField: UITextField?
    var passwordTextField: UITextField?
    var loginButton: UIButton?
    
    var singleTap: UITapGestureRecognizer?
    let keyboardMan = KeyboardMan()
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundImageView = UIImageView(image: UIImage(named: "login_background"))
        self.backgroundImageView!.frame = self.view.frame
        self.backgroundImageView!.contentMode = .ScaleToFill
        self.view.addSubview(self.backgroundImageView!)
        
        self.contentView = UIView(frame: self.view.frame)
        self.contentView!.alpha = 0
        self.view.addSubview(contentView!)
        
        let topPartTopConstraint = Ruler.iPhoneVertical(70, 130, 130, 130).value
        
        let wisLabel = UILabel()
        wisLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 40)!
        wisLabel.text = "WISDRI"
        wisLabel.textColor = UIColor.wisLogoColor()
        contentView!.addSubview(wisLabel)
        wisLabel.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(contentView!)
            make.top.equalTo(contentView!).offset(topPartTopConstraint)
        }
        
        let wisSummaryLabel = UILabel()
        wisSummaryLabel.font = wisFont(23)
        wisSummaryLabel.text = "生产数据管理"
        wisSummaryLabel.textColor = UIColor.wisLogoColor()
        contentView!.addSubview(wisSummaryLabel)
        wisSummaryLabel.snp_makeConstraints{ (make) -> Void in
            make.centerX.equalTo(contentView!)
            make.top.equalTo(wisLabel.snp_bottom).offset(8)
        }
        
        self.userNameTextField = UITextField()
        self.userNameTextField!.textColor = UIColor.wisLogoColor()
        self.userNameTextField!.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.userNameTextField!.font = wisFont(15)
        self.userNameTextField!.layer.cornerRadius = 3
        self.userNameTextField!.layer.borderWidth = 0.5
        self.userNameTextField!.keyboardType = .ASCIICapable
        self.userNameTextField!.returnKeyType = .Next
        self.userNameTextField!.layer.borderColor = UIColor.wisLogoColor().CGColor
        self.userNameTextField!.placeholder = "用户名"
        self.userNameTextField!.clearButtonMode = .Always
        self.userNameTextField!.autocapitalizationType = .None
        self.userNameTextField!.autocorrectionType = .No
        self.userNameTextField!.tag = 1
        self.userNameTextField!.delegate = self
        
        if let username = NSUserDefaults.standardUserDefaults().objectForKey("username") {
            self.userNameTextField!.text = (username as! String)
        }
        
        let userNameIconImageView = UIImageView(image: UIImage(named: "icon_account")!.imageWithRenderingMode(.AlwaysTemplate))
        userNameIconImageView.frame = CGRectMake(0, 0, 34, 22)
        userNameIconImageView.tintColor = UIColor.wisLogoColor()
        userNameIconImageView.contentMode = .ScaleAspectFit
        self.userNameTextField!.leftView = userNameIconImageView
        self.userNameTextField!.leftViewMode = .Always
        
        contentView!.addSubview(self.userNameTextField!)
        
        let bottomPartTopConstraint = Ruler.iPhoneVertical(100, 120, 200, 240).value
        let bottomPartWidthConstraint = Ruler.iPhoneVertical(250, 270, 300, 300).value
        
        self.userNameTextField!.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(wisSummaryLabel.snp_bottom).offset(bottomPartTopConstraint)
            make.centerX.equalTo(contentView!)
            make.width.equalTo(bottomPartWidthConstraint)
            make.height.equalTo(38)
        }

        self.passwordTextField = UITextField()
        self.passwordTextField!.textColor = UIColor.wisLogoColor()
        self.passwordTextField!.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.passwordTextField!.font = wisFont(15)
        self.passwordTextField!.layer.cornerRadius = 3
        self.passwordTextField!.layer.borderWidth = 0.5
        self.passwordTextField!.keyboardType = .ASCIICapable
        self.passwordTextField!.returnKeyType = .Done
        self.passwordTextField!.secureTextEntry = true
        self.passwordTextField!.layer.borderColor = UIColor.wisLogoColor().CGColor
        self.passwordTextField!.placeholder = "密码"
        self.passwordTextField!.clearButtonMode = .Always
        self.passwordTextField!.tag = 2
        
        let passwordIconImageView = UIImageView(image: UIImage(named: "icon_lock")!.imageWithRenderingMode(.AlwaysTemplate))
        passwordIconImageView.frame = CGRectMake(0, 0, 34, 22)
        passwordIconImageView.contentMode = .ScaleAspectFit
        passwordIconImageView.tintColor = UIColor.wisLogoColor()
        self.passwordTextField!.leftView = passwordIconImageView
        self.passwordTextField!.leftViewMode = .Always
        self.passwordTextField?.delegate = self
        
        contentView!.addSubview(self.passwordTextField!)
        
        self.passwordTextField!.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(self.userNameTextField!.snp_bottom).offset(15)
            make.centerX.equalTo(contentView!)
            make.width.equalTo(bottomPartWidthConstraint)
            make.height.equalTo(38)
        }
        
        self.loginButton = UIButton()
        self.loginButton!.setTitle("登  录", forState: .Normal)
        self.loginButton!.backgroundColor = UIColor.wisLogoColor()
        self.loginButton!.titleLabel!.font = wisFont(20)
        self.loginButton!.layer.cornerRadius = 3
        self.loginButton!.layer.borderWidth = 0.5
        self.loginButton!.layer.borderColor = UIColor.wisLogoColor().CGColor
        contentView!.addSubview(self.loginButton!)
        
        self.loginButton!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.passwordTextField!.snp_bottom).offset(20)
            make.centerX.equalTo(contentView!)
            make.width.equalTo(bottomPartWidthConstraint)
            make.height.equalTo(38)
        }
        
        // self.loginButton?.addTarget(self, action: #selector(LoginViewController.loginClick(_:)), forControlEvents: .TouchUpInside)
        
//        let forgetPasswordLabel = UILabel()
//        forgetPasswordLabel.alpha = 0.8
//        forgetPasswordLabel.font = wisFont(12)
//        forgetPasswordLabel.text = "忘记密码了?"
        
//        contentView!.addSubview(forgetPasswordLabel)
        
//        forgetPasswordLabel.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(self.loginButton!.snp_bottom).offset(14)
//            make.right.equalTo(self.loginButton!)
//        }
        
        let footLabel = UILabel()
        footLabel.alpha = 0.8
        footLabel.font = wisFont(12)
        footLabel.text = "© 2016 WISDRI"
        footLabel.textColor = UIColor.wisLogoColor()
        
        contentView!.addSubview(footLabel)
        
        footLabel.snp_makeConstraints{ (make) -> Void in
            make.bottom.equalTo(contentView!).offset(-20)
            make.centerX.equalTo(contentView!)
        }
        
        self.view.userInteractionEnabled = true
        
        #if (arch(x86_64) || arch(i386)) && os(iOS)
            
        #else
            
        keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in
            print("appear \(appearPostIndex), \(keyboardHeight), \(keyboardHeightIncrement)")
            if let strongSelf = self {
                
                strongSelf.view.frame.origin.y -= keyboardHeightIncrement
                strongSelf.view.frame.size.height += keyboardHeightIncrement
                strongSelf.view.layoutIfNeeded()
            }
        }
        
        keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in
            print("disappear \(keyboardHeight)\n")
            if let strongSelf = self {
                strongSelf.view.frame.origin.y += keyboardHeight
                strongSelf.view.frame.size.height -= keyboardHeight
                strongSelf.view.layoutIfNeeded()
            }
        }
        
        #endif
        
        // validating inputs
        let userNameValid = userNameTextField!.rx_text
            .map { $0.characters.count >= minimalUserNameLength }
            .shareReplay(1) // without this map would be executed once for each binding, rx is stateless by default
        
        userNameValid.subscribeNext{ valid in
            if valid {
                self.passwordTextField!.backgroundColor = UIColor(white: 1, alpha: 0.1)
            } else {
                self.passwordTextField!.backgroundColor = UIColor.wisLogoColor().colorWithAlphaComponent(0.4)
            }
        }.addDisposableTo(disposeBag)
        
        let passwordValid = passwordTextField!.rx_text
            .map { $0.characters.count >= minimalPasswordLength }
            .shareReplay(1)
        
        let allValid = Observable.combineLatest(userNameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        allValid.subscribeNext { valid in
            if valid {
                self.loginButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.loginButton!.backgroundColor = UIColor.wisLogoColor()
            } else {
                self.loginButton!.setTitleColor(UIColor.lightGrayColor().colorWithAlphaComponent(0.8), forState: .Normal)
                self.loginButton!.backgroundColor = UIColor.wisLogoColor().colorWithAlphaComponent(0.4)
            }
        }.addDisposableTo(disposeBag)
        
        // Binding enabled property
        userNameValid
            .bindTo(passwordTextField!.rx_enabled)
            .addDisposableTo(disposeBag)
        
        allValid
            .bindTo(loginButton!.rx_enabled)
            .addDisposableTo(disposeBag)
        
        // initial view model
        self.viewModel = LoginViewModel(input: (userNameTextField!.rx_text.asObservable(), passwordTextField!.rx_text.asObservable(), loginButton!.rx_tap.asObservable()))
        
        self.viewModel?.loginPhase?.subscribeNext{ phase in
            switch phase {
            case .StandBy:
                // do nothing
                break
            case .InProgress:
                SVProgressHUD.showWithStatus("正在登录")
                
            case .Success(_):
                SVProgressHUD.showSuccessWithStatus("登录成功")
                NSUserDefaults.standardUserDefaults().setObject(self.userNameTextField!.text, forKey: "username")
                
                let now = NSDate()
                SearchParameter["date"] = dateFormatterForSearch(now)
                let hour = dateFormatterGetHour(now)
                SearchParameter["shiftNo"] = getShiftNo(hour)
                
                delay(0.25, work: {
                    WISCommon.currentAppDelegate.startMainStory()
                })
                break
                
            case .Failure(let errorString):
                wisError(errorString)
                break
            }
        }.addDisposableTo(disposeBag)
        
        singleTap = UITapGestureRecognizer()
        
        singleTap!.rx_event
            .subscribeNext { [weak self] _ in
                self?.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
        view.addGestureRecognizer(singleTap!)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1) { () -> Void in
            self.contentView!.alpha = 1
        }
//        UIView.animateWithDuration(20) { () -> Void in
//            self.backgroundImageView?.frame = CGRectMake(-1*( 1000 - SCREEN_WIDTH )/2, 0, SCREEN_HEIGHT+500, SCREEN_HEIGHT+500)
//        }
    }

}

extension LoginViewController: UITextFieldDelegate {
    // The "next" button doesn't work till now.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.userNameTextField) {
            self.passwordTextField!.becomeFirstResponder()
            return true
        }
        else if (textField == self.passwordTextField) {
            self.passwordTextField!.resignFirstResponder()
            self.viewModel?.loginWith(userName: (self.viewModel?.validatedUserName)!, password: (self.viewModel?.validatedPassword)!)
            return true
        } else {
            return false
        }
    }
}
