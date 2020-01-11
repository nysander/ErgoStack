//
//  String.swift
//  ErgoStack
//
//  Created by Pawel Madej on 11/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

extension String {
  func stringByAddingPercentEncodingForRFC3986() -> String? {
    let unreserved = "-._~/?"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)
    return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
  }
}
