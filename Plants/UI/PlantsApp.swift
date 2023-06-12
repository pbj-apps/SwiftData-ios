//
//  PlantsApp.swift
//  plants
//
//  Created by Thibault Gauche on 09/06/2023.
//

import SwiftUI
import SwiftData

@main
struct PlantsApp: App {

    var body: some Scene {
        WindowGroup {
            PlantList()
        }
        .modelContainer(for: Plant.self)
    }
}
