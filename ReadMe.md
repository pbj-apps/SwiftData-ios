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

Now, whenever you are going to add or remove an object from the modelContext, that object will be updated locally in the database. Let's do this :

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

SwiftData will now create a `{databaseName}.store` file, this will be your local database, whenever you are creating a project in xcode you can select if your database need to be saved in iCloud or not and it will be transparent for you as a developer, you just need to create a container for your app in [developer.apple.com](developer.apple.com) and link it in the general tab of your project.

But this is it, congrats! You can now store object locally in ios 17+. You can find a complete project with the concepts described above [here](https://github.com/pbj-apps/SwiftDataWWDC23-ios).

There will be a part 2 of this guide with more in-depth code about SwiftData. 
