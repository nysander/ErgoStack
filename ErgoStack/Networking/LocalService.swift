//
//  LocalService.swift
//  ErgoStack
//
//  Created by Pawel Madej on 11/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

class LocalService: LocalDataProvider {
    var localStore: LocalStore

    init() {
        self.localStore = DefaultLocalStoreAgent()
    }
}
