# ProgressX-2
Fitness logging app made with Swift and the SwiftUI framework

## Project Background
ProgressX-2 is an iOS App that 

## Application structure
The small core of the app is the `ViewRouter` class and the `ProgressX_2App` class. All views are wrapped in a `SideBarView` which is accessed with a EnviromentObject

## Hardware
Simulator tested on IPhone 15 and IPhone SE, built for any iOS device (arm64).

## DataModel / Backend
The data backend for this applications consists of three parts.

-   The CoreData model defined in the `ProgressX_2.xcdatamodeld` file, this is basicly a file to set up a underlying SQLite database and its the intended way to create a CoreDataModel in Swift projects.
-   Extensions for advanced constraints in the database can be found in `ProgressX-2/DataModel/NSManagedObjectExtensions`, these files exist because the XCode interface/wrapper used to create the underlying SQLite database dont have the functionality to create more advanced constraints so it has to be done when validating the objects on the "Swift-side" of things before passing them over to the "SQLite-side".
-   The PersistenceController class in `ProgressX-2/DataModel/Persistence` initializes the database connection during run-time, testing and previews. The class has two static members which are themselves PersistenceControllers. One controller called **shared** which is the "live database" controller intended for the app in production and run-time. The other controller called **preview** is intended to be used in testing and previews since it's an **in-memory** database and no changes are stored persistently.

### Assets
There is an JSON file in `ProgressX-2/Assets` with data for some basic Exercise entities that is generated when a new profile is  created. We chose to do it this way to save us from writing more boilerplate.



