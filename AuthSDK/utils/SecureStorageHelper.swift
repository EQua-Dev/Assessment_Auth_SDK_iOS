//
//  SecureStorageHelper.swift
//  AuthSDK
//
//  Created by Richard Uzor on 03/05/2025.
//

import Foundation
import Security

public class SecureStorageHelper {
    
    public static func store(user: UserData) {
        if let data = try? JSONEncoder().encode(user) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "auth_user",
                kSecValueData as String: data
            ]
            SecItemDelete(query as CFDictionary) // Remove existing
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    public static func retrieveUser() -> UserData? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "auth_user",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == noErr,
           let data = result as? Data {
            return try? JSONDecoder().decode(UserData.self, from: data)
        }
        return nil
    }
}

