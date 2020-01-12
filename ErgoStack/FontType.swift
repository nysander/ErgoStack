//
//  FontType.swift
//  ErgoStack
//
//  Created by Pawel Madej on 12/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

enum FontType {
    case headline
    case body
    case caption
    case title

    var suffix: String {
        switch self {
        case .headline:
            return "-headline"
        case .caption:
            return "-caption1"
        case .title:
            return "-title1"
        default:
            return "-body"
        }
    }
}
