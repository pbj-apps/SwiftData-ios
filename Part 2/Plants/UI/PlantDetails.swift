//
//  PlantDetails.swift
//  Plants
//
//  Created by Thibault Gauche on 12/06/2023.
//

import SwiftUI

struct PlantDetails: View {
	var plant: Plant

	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Image(plant.iconName)
					.resizable()
					.aspectRatio(contentMode: .fit)
				Text(plant.name)
					.font(.title)
					.multilineTextAlignment(.center)
					.padding(.vertical, 10)
				Text(plant.details)
					.font(.body)
					.foregroundStyle(Color.accentColor)
				Text("Water")
					.font(.title)
					.padding(.top, 20)
				ForEach(plant.waterList.sorted(by: {
					$0.date > $1.date
				})) {
					Text($0.date.dMMMy)
						.font(.body)
						.foregroundStyle(Color.accentColor)
				}
				Spacer()
			}
			.padding(.top, -100)
			.padding()
		}
		.background(Color.background)
		.toolbar {
			ToolbarItem {
				Button(action: {
					let newWater = Water(date: Date())
					plant.waterList.append(newWater)
				}) {
					Label("Add Item", systemImage: "drop")
				}
			}
		}
	}
}

@MainActor #Preview {
	PlantDetails(plant: .preview)
		.modelContainer(PreviewSampleData.container)
}
