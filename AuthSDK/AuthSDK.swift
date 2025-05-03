//
//  AuthSDK.swift
//  AuthSDK
//
//  Created by Richard Uzor on 03/05/2025.
//

import Foundation
import SwiftUI

public class AuthSDKClass {
    public static func launch(config: AuthConfig, onSubmit: @escaping (UserData) -> Void) -> some View {
        return AuthView(config: config, onSubmit: onSubmit)
    }
}
