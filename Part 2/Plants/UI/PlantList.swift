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

	private var needWaterPlants: [Plant] {
		let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
		let filteredPlants = try? plants.filter(#Predicate { item in
			!item.waterList.contains(where: { date < $0.date })
		})
		return filteredPlants ?? []
	}

	private var okayPlants: [Plant] {
		Array(Set(plants).subtracting(needWaterPlants))
	}

	var body: some View {
		NavigationView {
			VStack {
				List {
					if !needWaterPlants.isEmpty {
						Section(header: Text("We need water")) {
							ForEach(needWaterPlants.sorted(by: { $0.name < $1.name })) {
								plantRow($0)
							}
							.onDelete(perform: deleteItems)
						}
					}
					
					if !okayPlants.isEmpty {
						Section(header: Text("We are okay for now")) {
							ForEach(okayPlants.sorted(by: { $0.name < $1.name })) {
								plantRow($0)
							}
							.onDelete(perform: deleteItems)
						}
					}
				}
				.listStyle(.plain)
				Spacer()
				Image("StudioLogo")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: 50)
					.onTapGesture {
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
							plantItem($0)
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

	private func plantItem(_ plant: Plant) -> some View {
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

	private func plantRow(_ plant: Plant) -> some View {
		NavigationLink {
			PlantDetails(plant: plant)
		} label: {
			Text(plant.name).font(.body)
		}
		.swipeActions(edge: .leading, allowsFullSwipe: false) {
			Button (action: {
				let newWater = Water(date: Date())
				modelContext.insert(newWater)
				plant.waterList.append(newWater)
			}, label: {
				Label("Water", systemImage: "drop.fill").foregroundStyle(.white)
			}).tint(.blue)
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

@MainActor #Preview {
	PlantList()
		.modelContainer(PreviewSampleData.container)
}
