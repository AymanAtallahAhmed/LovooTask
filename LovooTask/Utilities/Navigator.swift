//
//  Navigator.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/19/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

protocol Navigator {
    //init(window: UIWindow, navController: UINavigationController)
    func navigate(to destination: Destination)
    func pop()
    func logout()
    func start()
}

class AppNavigator: Navigator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow, navController: UINavigationController) {
        self.window = window
        self.navigationController = navController
    }

    
    func navigate(to destination: Destination) {
        let viewController: UIViewController
        switch destination {
        case .roomsVC:
            let roomsVC = RoomsVC.init(navigator: self)
            //viewController = roomsVC
            self.setViewControllerAsRoot(viewController: roomsVC)
            return
        case let .detailedRooomVC(fact):
            let detailedRoomVC = DetailedRoomVC.init(fact: fact, navigator: self)
            viewController = detailedRoomVC
        case let .bookRoomVC(room):
            let bookRoomVC = BookRoomVC.init(room: room, navigator: self)
            viewController = bookRoomVC
        }
        
        navigate(to: viewController, from: navigationController)
    }
    
    private func navigate(to target: UIViewController, from sender: UIViewController?) {
        if let navController = sender as? UINavigationController {
            navController.pushViewController(target, animated: true)
        } else {
            sender?.present(target, animated: true)
        }
    }
    
    private func setViewControllerAsRoot(viewController: UIViewController) {
        if viewController is LoginVC {
            self.window.rootViewController = viewController
            window.makeKeyAndVisible()
        } else {
            self.window.rootViewController = navigationController
            navigationController.pushViewController(viewController, animated: false)
        }
        window.makeKeyAndVisible()
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func logout() {
        KeyChainManager.deleteAll()
        UDHelper.isUserLoggedIn = false
        
        let coreDataManager: CoreDataManager = .init()
        coreDataManager.removeAll()
        
        let loginVC: LoginVC = .init(navigator: self)
        setViewControllerAsRoot(viewController: loginVC)
    }
    
    func start() {
        print(UDHelper.isUserLoggedIn)
        if UDHelper.isUserLoggedIn {
            let roomsVC = RoomsVC.init(navigator: self)
            window.rootViewController = navigationController
            navigationController.pushViewController(roomsVC, animated: false)
        } else {
            let loginVC = LoginVC.init(navigator: self)
            window.rootViewController = loginVC
        }
        
        window.makeKeyAndVisible()
    }
}

enum Destination {
    case roomsVC
    case detailedRooomVC(fact: LovooFact)
    case bookRoomVC(room: Room)
}
