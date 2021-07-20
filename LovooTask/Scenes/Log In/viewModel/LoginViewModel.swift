//
//  LoginViewModel.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/18/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class LoginViewModel {
    private let networkManager: NetworkManager = .init()
    private let disposeBag: DisposeBag = .init()
    let isLoggedIn: BehaviorRelay<Bool> = .init(value: false)
    let userName: BehaviorRelay<String> = .init(value: "")
    let password: BehaviorRelay<String> = .init(value: "")
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(userName, password).map { username, pass  in
            return username.count > 5  &&  pass.count > 5
        }
    }
    
    func login() {
        let headers: HTTPHeaders = [.authorization(username: userName.value,
                                                   password: password.value)]
       
        networkManager.getObjects(ofType: [Room].self, headers: headers)
            .subscribe(onNext: { [weak self] rooms in
                print(rooms)
                if let usernameData = self?.userName.value.data(using: .utf8) ,
                    let passwordData = self?.password.value.data(using: .utf8) {
                    KeyChainManager.save(key: LVConstant.usernameKey, data: usernameData)
                    KeyChainManager.save(key: LVConstant.passwordKey, data: passwordData)
                }
                
                UDHelper.isUserLoggedIn = true
                self?.isLoggedIn.accept(true)
            }, onError: { (err) in
                print(err)
        }).disposed(by: disposeBag)
    }
    
}
