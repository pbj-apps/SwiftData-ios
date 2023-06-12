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
		VStack {
			Image(plant.iconName)
				.resizable()
				.aspectRatio(contentMode: .fit)
			Text(plant.name)
				.font(.title)
				.multilineTextAlignment(.center)
				.padding(.vertical, 10)
			Text(plant.details)
				.font(.body)
			Spacer()
		}
		.padding()
		.background(Color.background.opacity(0.6))

	}
}

#Preview {
	PlantDetails(plant: .preview)
		.modelContainer(for: Plant.self, inMemory: true)
}
