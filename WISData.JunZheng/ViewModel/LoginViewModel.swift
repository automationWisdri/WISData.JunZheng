//
//  LoginViewModel.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 8/16/16.
//  Copyright © 2016 wisdri. All rights reserved.
//

import Foundation
import RxSwift

enum ValidationResult {
    case OK(result: String)
    case Empty
    case Validating
    case Failed(message: String)
}

enum LoginPhase<T> {
    case StandBy
    case InProgress
    case Success(value: T)
    case Failure(error: String)
}

class LoginViewModel: ViewModel {
    /// User name entered by the user, or from local storage
    var validatedUserName: String?
    /// Password entered by the user, or from KeyChain
    var validatedPassword: String?
    
    // Has user logged in
    var loginPhase: BehaviorSubject<LoginPhase<String>>?
    
    init(input: (
        userName: Observable<String>,
        password: Observable<String>,
        loginTaps: Observable<Void>)) {
        super.init()
        
        input.userName
            .subscribeNext { [weak self] name in
            self!.validatedUserName = name
            }
            .addDisposableTo(disposeBag)
        
        input.password
            .subscribeNext { [weak self] password in
                self!.validatedPassword = password
            }
            .addDisposableTo(disposeBag)
        
        let userNameAndPassword = Observable.combineLatest(input.userName, input.password) { ($0, $1) }

        userNameAndPassword.subscribeNext {
            print("userName: \($0.0), password: \($0.1)")
        }
        
        loginPhase = BehaviorSubject<LoginPhase<String>>(value: LoginPhase.StandBy)
        
        input.loginTaps.withLatestFrom(userNameAndPassword)
            .subscribeNext { [weak self] (name, password) in
                self!.loginWith(userName: name, password: password)
                
        }.addDisposableTo(disposeBag)
    }
    
    func loginWith(userName userName: String, password: String) -> Void {
        self.loginPhase?.onNext(LoginPhase.InProgress)
        User.login(username: userName, password: password) {[weak self] (response: WISValueResponse<String>) -> Void in
            if response.success {
                self?.loginPhase?.onNext(LoginPhase.Success(value: response.value!))
            } else {
                self?.loginPhase?.onNext(LoginPhase.Failure(error: response.message))
            }
        }
    }
}

