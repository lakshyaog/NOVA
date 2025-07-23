import Foundation

// MARK: - Array Extension for Safe Access
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
//  Extension.swift
//  NOVA
//
//  Created by Lakshya Solanki on 03/06/25.
//

