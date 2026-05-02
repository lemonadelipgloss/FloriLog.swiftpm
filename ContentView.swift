import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    @State private var showIntro = false
    
    var body: some View {
        Group {
            if showIntro {
                IntroView(showIntro: $showIntro)
                    .transition(.opacity)
            } else {
                CalendarGardenView()
            }
        }
        .onAppear {
            if !hasSeenIntro {
                showIntro = true
            }
        }
        .onChange(of: showIntro) { newValue in
            if !newValue {
                hasSeenIntro = true
            }
        }
    }
}
