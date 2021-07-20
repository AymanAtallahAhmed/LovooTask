//
//  LoginVC.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/18/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    private let viewModel: LoginViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    private let navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: "LoginVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    private func setupUI() {
        [usernameTF, passwordTF, loginButton]
            .forEach({ $0?.setView(corner: 12) })
    }
    
    private func bind() {
        usernameTF.rx
            .text.map({ $0 ?? "" })
            .bind(to: viewModel.userName)
            .disposed(by: disposeBag)
        passwordTF.rx
            .text.map({ $0 ?? "" })
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isValid()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.isValid()
            .map({ $0 ? 1 : 0.5})
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel.isLoggedIn
            .subscribe(onNext: { [weak self]  loggedSuccessfully in
                if loggedSuccessfully {
                    self?.navigator.navigate(to: .roomsVC)
                }
            }).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.login()
        }).disposed(by: disposeBag)
    }
}
