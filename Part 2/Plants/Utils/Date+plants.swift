//
//  Date+planys.swift
//  Plants
//
//  Created by Thibault Gauche on 19/06/2023.
//

import Foundation

extension Date {
	var dMMMy: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "d MMM - HH:hh"
		return formatter.string(from: self)
	}
}
