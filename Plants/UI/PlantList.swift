//
//  PlantList.swift
//  plants
//
//  Created by Thibault Gauche on 09/06/2023.
//

import SwiftUI
import SwiftData

struct PlantList: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var plants: [Plant]
	@State private var isPlantsListPresented = false

	var body: some View {
		NavigationView {
			List {
				ForEach(plants) { item in
					NavigationLink {
						PlantDetails(plant: item)
					} label: {
						Text(item.name).font(.body)
					}
				}
				.onDelete(perform: deleteItems)
			}
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
						Text("Select a Plant").font(.largeTitle)
							.padding([.vertical, .leading], 20)

						Spacer()
					}
					LazyVGrid(columns: [GridItem(.flexible(minimum: 180)),
															GridItem(.flexible(minimum: 180))]) {
						ForEach(SamplePlants.contents) {
							plantRow($0)
						}
					}
				}
			})
			.navigationTitle("My Plants")
			.background(Color.background)
		}

	}

	private func plantRow(_ plant: Plant) -> some View {
		VStack(alignment: .center) {
			Spacer()
			Image(plant.iconName).resizable().aspectRatio(contentMode: .fit)
			Text(plant.name).multilineTextAlignment(.center).font(.body).lineLimit(2).minimumScaleFactor(0.6).frame(height: 60).padding(.horizontal, 10)
		}
		.background(Color.background.opacity(0.6))
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
