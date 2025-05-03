//
//  AuthConfig.swift
//  AuthSDK
//
//  Created by Richard Uzor on 03/05/2025.
//

import SwiftUI

public struct AuthConfig {
    public var primaryColor: Color
    public var backgroundColor: Color
    public var textColor: Color
    public var font: Font
    public var submitButtonText: String
    public var showUsername: Bool

    // Default init
    public init() {
        self.primaryColor = .blue
        self.backgroundColor = .white
        self.textColor = .black
        self.font = .system(size: 16)
        self.submitButtonText = "Submit"
        self.showUsername = true
    }

    // New init using hex strings
    public init(
        primaryColorHex: String,
        backgroundColorHex: String,
        textColorHex: String,
        submitButtonText: String,
        showUsername: Bool
    ) {
        self.primaryColor = Color(hex: primaryColorHex) ?? .blue
        self.backgroundColor = Color(hex: backgroundColorHex) ?? .white
        self.textColor = Color(hex: textColorHex) ?? .black
        self.font = .system(size: 16)
        self.submitButtonText = submitButtonText
        self.showUsername = showUsername
    }
}
