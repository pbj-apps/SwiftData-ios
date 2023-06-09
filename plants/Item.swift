//
//  Item.swift
//  plants
//
//  Created by Thibault Gauche on 09/06/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
