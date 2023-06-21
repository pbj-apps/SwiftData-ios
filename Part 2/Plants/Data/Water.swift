//
//  Water.swift
//  Plants
//
//  Created by Thibault Gauche on 15/06/2023.
//

import Foundation
import SwiftData

@Model
final class Water {
	var date: Date
	var plant: Plant?

	init(date: Date) {
		self.date = date
	}
}
