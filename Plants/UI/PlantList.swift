//
//  PlantList.swift
//  plants
//
//  Created by Thibault Gauche on 09/06/2023.
//

import SwiftUI
import SwiftData

struct PlantList: View {
	@Environment(\.openURL) var openURL
	@Environment(\.modelContext) private var modelContext
	@Query private var plants: [Plant]
	@State private var isPlantsListPresented = false

	var body: some View {
		NavigationView {
			VStack {
				List {
					ForEach(plants) { plant in
						NavigationLink {
							PlantDetails(plant: plant)
						} label: {
							Text(plant.name).font(.body)
						}
					}
					.onDelete(perform: deleteItems)
				}
				.listStyle(.plain)
				Spacer()
				Image("StudioLogo").resizable().aspectRatio(contentMode: .fit).frame(height: 50).onTapGesture {
					openURL(URL(string: "https://buildwithstudio.com")!)
				}
			}
			.padding(.vertical, 20)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
				ToolbarItem {
					Button(action: {
						isPlantsListPresented = true
					}) {
						Label("Add Item", systemImage: "plus")
					}
				}
			}
			.sheet(isPresented: $isPlantsListPresented, content: {
				ScrollView {
					HStack {
						Text("Select a Plant")
							.font(.largeTitle)
							.padding([.vertical, .leading], 20)
							.foregroundStyle(Color.accentColor)
						Spacer()
					}
					LazyVGrid(columns: [GridItem(.flexible(minimum: 180)),
															GridItem(.flexible(minimum: 180))]) {
						ForEach(SamplePlants.contents) {
							plantRow($0)
						}
					}
				}
				.background(Color.background)
			})
			.navigationTitle("My Plants")
			.tint(Color.accentColor)
			.background(Color.background)
		}

	}

	private func plantRow(_ plant: Plant) -> some View {
		VStack(alignment: .center) {
			Spacer()
			Image(plant.iconName).resizable().aspectRatio(contentMode: .fit)
			Text(plant.name).multilineTextAlignment(.center).font(.body).lineLimit(2).minimumScaleFactor(0.6).frame(height: 60).padding(.horizontal, 10)
		}
		.background(Color.accentColor.opacity(0.2))
		.cornerRadius(5)
		.padding()
		.onTapGesture {
			isPlantsListPresented = false
			add(plant: plant)
		}
	}

	private func add(plant: Plant) {
		withAnimation {
			modelContext.insert(plant)
		}
	}

	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			for index in offsets {
				modelContext.delete(plants[index])
			}
		}
	}
}

#Preview {
	PlantList()
		.modelContainer(for: Plant.self, inMemory: true)
}
