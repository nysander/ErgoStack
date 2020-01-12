//
//  DefaultNetworkingAgent.swift
//  ErgoStack
//
//  Created by Pawel Madej on 11/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

class DefaultNetworkingAgent: Networking {
    var sessionConfig: URLSessionConfiguration
    var session: URLSession

    init() {
        self.sessionConfig = URLSessionConfiguration.default
        self.sessionConfig.waitsForConnectivity = true
        self.sessionConfig.timeoutIntervalForResource = 60 * 60 // 1 hour

        self.session = URLSession(configuration: self.sessionConfig)
    }
}
