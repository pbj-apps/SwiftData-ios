# SwiftData

## How to start with SwiftData?

 SwiftData is a new framework available with iOS 17. It enables developers to add persistence to an app quickly and without external dependencies. 

Let's build a small app to list the plants in my house to demonstrate how we can utilize SwiftData.  

Let's first create a struct for the plant object : 

``` swift
struct Plant {
	var name: String
	var details: String
	var iconName: String
}
```

Let's now check the [documentation](https://developer.apple.com/documentation/swiftdata/model) about Model in SwiftData. `Model` is a new macro that was added with iOS 17 which will convert a swift class into a stored model that will be managed by SwiftData. If we look into the macro, we can see that `Model` is conforming to the protocol `PersistentModel`, with the signature : `protocol PersistentModel : AnyObject, Observable, Hashable, Identifiable`. As we can see, PersistanceModel is conforming to the new `Observable` protocol, so our SwiftUI app will update itself if there is any change to our Plant object. Let's update `Plant` and make it conform to the `Model` macro :

``` swift
@Model
final class Plant {
	var name: String
	var details: String
	var iconName: String

	init(name: String, details: String, iconName: String) {
		self.name = name
		self.details = details
		self.iconName = iconName
	}
}
```

Our struct needed to be updated to a class to conform to the macro `Model`. Let's create the root view of our app : 

``` swift
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
```
 Now, we are going to build a List that will display all the plants saved in  SwiftData.

``` swift
import SwiftUI
import SwiftData

struct PlantList: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var plants: [Plant]

	var body: some View {
	    List {
		    ForEach(plants) { plant in
			    Text(plant.name)
            }
        }
    }
}
```

There are a few interesting things in those two views. First we have our root scene that has a `modelContainer`, an object that manages an app's schema and the model storage configuration. The schema is an object that maps model classes to data in the model store. We don't need any configuration right now since our app has only one type of model : Plant. 
In our PlantList view, there is a `ModelContext` this object is responsible for the in-memory model data and coordination with the model container to successfully persist that data. To get a context for our model container that’s bound to the main actor (our PlantsApp); we use the modelContext environment variable.

Now, whenever an object gets added or removed from the modelContext, that object will be updated locally in the database. Let's do this :

``` swift
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
```

SwiftData will now create a `{databaseName}.store` file which will be your local database. Whenever you are creating a project in xcode you can select if your database need to be saved in iCloud or not and it will be transparent for you as a developer, you just need to create a container for your app in [developer.apple.com](developer.apple.com) and link it in the general tab of your project.

And that’s it - congrats! You can now store object locally in ios 17+. You can find a complete project with the concepts described above [here](https://github.com/pbj-apps/SwiftDataWWDC23-ios).

There will be a part 2 of this guide with more in-depth code about SwiftData. 


## How to continue with SwiftData? - part 2

Let's continue with our plants. I want to know when I watered each plants, so let's create a new model: 

``` swift 
@Model
final class Water {
	var date: Date
	var plant: Plant?
}
```

Obviously we want to store this data locally so we mark it with the `Model` macro. And we also need to store for each plant when we watered it. Let's add a property : 
``` swift
@Model
final class Plant {
	@Attribute(.unique) var name: String
	var details: String
	var iconName: String
	@Relationship(.cascade, inverse: \Water.plant) var waterList: [Water] = []
}
```

As we can see we added a new property that will store all the Water object, we added the `Relationship` macro to that property, this macro specifies the options that SwiftData needs to manage the annotated property as a relationship between two models. The Relationship macro has a `deleteRule` in parameter (cascade, deny, noAction, nullify) . In our case we set it to .cascade, if we remove a plant from our dataset, every water tied to this plant will be deleted. The `inverse` parameter is here to forward the plant object to water. 

Same as before, we need to store the water object when needed : 

``` swift
let newWater = Water(date: Date())
modelContext.insert(newWater)
plant.waterList.append(newWater)
```

We do this from the home where we have access to the ModelContext, let's try to do the same from the details view. We are also going to display the dates :

``` swift 
ForEach(plant.waterList.sorted(by: { $0.date > $1.date })) {
	Text($0.date.dMMMy)
		.font(.body)
		.foregroundStyle(Color.accentColor)
}
```
As you go through the list, display the dates in a text. Quick note : you shouldn't do the sorting in the ForEach the way it is written here as the sort will be done every time this swiftUI view is refreshed. Instead, as a performance improvement, you should move the sort to a viewModel instead. But we're building a simple demo app here.

As discussed before, let's add water from the details view : 

``` swift 
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
```

We can see that we're not working with the modelContext directly, but since we are working with classes, hence references and not copy, the changes are forwarded to the model context.

I want to filter my plants to know which one I need to water today, as I'm watering my plant once a week. I'm going to use a predicate to filter the plants : 

``` swift 
private var needWaterPlants: [Plant] {
	let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
	let filteredPlants = try? plants.filter(#Predicate { item in
		!item.waterList.contains(where: { date < $0.date })
	})
	return filteredPlants ?? []
}
```
 
 This is a new macro introduced with iOS 17 `#Predicate` and it is a logical condition that evaluates to a Boolean value. You use predicates for operations like filtering a collection or searching for matching elements. And this is exactly what we do here. So we now have a list with two sections, one for the plants that need water and the other plants.

You are now capable of developing an app that will store data locally. You will find a lot more information [here](https://developer.apple.com/documentation/swiftdata), and if you have more questions don't hesitate to contact us via the [Studio](https://buildwithstudio.com) website. 

Cheers.