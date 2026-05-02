import SwiftUI

@main
struct MyApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var bouquetManager = BouquetManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(bouquetManager)
                .environment(\.font, .custom("Georgia", size: 17))
        }
    }
}
