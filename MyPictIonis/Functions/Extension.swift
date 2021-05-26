//
//  Extension.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 26/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}

extension String {
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
}
