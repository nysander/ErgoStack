//
//  UserDefaultConfig.swift
//  ErgoStack
//
//  Created by Pawel Madej on 08/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

enum UserDefaultsConfig {
    @UserDefault("demo", defaultValue: false)
    static var demo: Bool
}
