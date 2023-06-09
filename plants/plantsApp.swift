//
//  plantsApp.swift
//  plants
//
//  Created by Thibault Gauche on 09/06/2023.
//

import SwiftUI
import SwiftData

@main
struct plantsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
