//
//  SamplePlants.swift
//  plants
//
//  Created by Thibault Gauche on 09/06/2023.
//

import Foundation
import SwiftData

struct SamplePlants {
	static var contents: [Plant] = [
		Plant(name: "Sansevieria trifasciata laurentii", details: "Dracaena trifasciata is a species of flowering plant in the family Asparagaceae, native to tropical West Africa from Nigeria east to the Congo. It is most commonly known as the snake plant, Saint George's sword, mother-in-law's tongue, and viper's bowstring hemp, among other names", iconName: "SansevieriaTrifasciataLaurentii"),
		Plant(name: "Monstera deliciosa", details: "Monstera deliciosa, the Swiss cheese plant or split-leaf philodendron is a species of flowering plant native to tropical forests of southern Mexico, south to Panama. It has been introduced to many tropical areas, and has become a mildly invasive species in Hawaii, Seychelles, Ascension Island and the Society Islands.", iconName: "MonsteraDeliciosa"),
		Plant(name: "Cereus marinatocereus marinatus", details: "Lophocereus marginatus is a species of plant in the family Cactaceae. It is sometimes called Mexican fencepost cactus. It has columnar trunks that grow slowly to 12 feet (3.7 m) and may reach 20 feet (6.1 m) in height. Stems are 3 to 4 inches (7.6 to 10.2 centimetres) in diameter, with ribs 5 to 7 in (13 to 18 cm). Its central spine is about 3⁄8 inch (0.95 cm) in diameter with five to 9 radials and slightly yellowish in color. Its cuttings are sometimes used to create fences, as its spines are not as large or dangerous as some cacti.", iconName: "CereusMarinatocereusMarinatus"),
		Plant(name: "Calathea Kennedy", details: "Calathea is a genus of flowering plants belonging to the family Marantaceae. They are commonly called calatheas or (like their relatives) prayer plants.", iconName: "CalatheaKennedy"),
		Plant(name: "Alocasia Frydek", details: "Alocasia is a genus of rhizomatous or tuberous, broad-leaved, perennial, flowering plants from the family Araceae. There are about 90 accepted species native to tropical and subtropical Asia and eastern Australia. Around the world, many growers widely cultivate a range of hybrids and cultivars as ornamentals.", iconName: "AlocasiaFrydek"),
		Plant(name: "Scindapsus Pothos Pictus Silvery Ann", details: "Scindapsus is a genus of flowering plants in the family Araceae. It is native to Southeast Asia, New Guinea, Queensland, and a few western Pacific islands. The species Scindapsus pictus is common in cultivation. Scindapsus is not easily distinguishable from Epipremnum.", iconName: "ScindapsusPothosPictusSilveryAnn"),
		Plant(name: "Euphorbe", details: "Euphorbia is a very large and diverse genus of flowering plants, commonly called spurge, in the family Euphorbiaceae. Euphorbia is sometimes used in ordinary English to collectively refer to all members of Euphorbiaceae, not just to members of the genus.", iconName: "Euphorbe"),
		Plant(name: "Philodendron Melanochrysum", details: "Philodendron melanochrysum is a species of flowering plant in the family Araceae, endemic to the wet Andean foothills of Colombia, growing at approximately 500m above sea level in the provinces of Chocó and Antioquia but widely cultivated elsewhere as an ornamental.", iconName: "PhilodendronMelanochrysum")
	]
}


actor PreviewSampleData {
	@MainActor
	static var container: ModelContainer = {
		let schema = Schema([Plant.self, Water.self])
		let configuration = ModelConfiguration(inMemory: true)
		let container = try! ModelContainer(for: schema, configurations: [configuration])
		let sampleData: [any PersistentModel] = [
			Plant.preview
		]
		sampleData.forEach {
			container.mainContext.insert($0)
		}
		return container
	}()
}
