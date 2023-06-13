//
//  Item.swift
//  plants
//
//  Created by Thibault Gauche on 09/06/2023.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Plant {
	@Attribute(.unique) var name: String
	var details: String
	var iconName: String

	init(name: String, details: String, iconName: String) {
		self.name = name
		self.details = details
		self.iconName = iconName
	}

	static var preview: Plant {
		Plant(name: "Alocasia Frydek", details: "Alocasia is a genus of rhizomatous or tuberous, broad-leaved, perennial, flowering plants from the family Araceae. There are about 90 accepted species native to tropical and subtropical Asia and eastern Australia. Around the world, many growers widely cultivate a range of hybrids and cultivars as ornamentals.", iconName: "AlocasiaFrydek")
	}
}
