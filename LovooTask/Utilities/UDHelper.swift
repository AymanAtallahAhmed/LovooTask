//
//  UDHelper.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/19/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import Foundation

class UDHelper {
    private static let userDefaults = UserDefaults.standard
    
    static var isUserLoggedIn: Bool {
        set { userDefaults.set(newValue, forKey: LVConstant.userLoggedInKey) }
        get { userDefaults.bool(forKey: LVConstant.userLoggedInKey) }
    }
}
