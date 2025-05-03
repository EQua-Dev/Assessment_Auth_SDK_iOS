//
//  UserData.swift
//  AuthSDK
//
//  Created by Richard Uzor on 03/05/2025.
//

import Foundation

public struct UserData: Codable {
    public let email: String
    public let password: String
    public let username: String?
    public let firstName: String
    public let lastName: String
}

