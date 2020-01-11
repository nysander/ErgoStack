//
//  APIService.swift
//  ErgoStack
//
//  Created by Pawel Madej on 11/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

class APIService: APIDataProvider {
    var network: Networking

    init() {
        self.network = DefaultNetworkingAgent()
    }
}