//
//  KeyChainManager.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/18/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import Security
import UIKit

class KeyChainManager {
    
    @discardableResult
    class func save(key: String, data: Data) -> OSStatus {
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String : data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Fetching data from KeyChain for that key
    func fetchWith(key: String) -> Data? {
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String : kCFBooleanTrue!,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        return status == noErr ? dataTypeRef as! Data? : nil
    }
    
    class func deleteAll()  {
        let secItemClasses =  [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity,
        ]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }
}
