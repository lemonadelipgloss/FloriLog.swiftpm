import SwiftUI
import CoreData

struct WeekSummaryButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showBouquet: Bool
    @Binding var selectedWeekEntries: [MoodEntry]
    @Binding var weekStart: Date
    
    let currentMonth: Date
    
    var body: some View {
        Button(action: {
            loadCurrentWeekEntries()
            showBouquet = true
        }) {
            VStack(spacing: 2) {
                ZStack {
                    ForEach(0..<5) { i in
                        Ellipse()
                            .fill(Theme.petalPink.opacity(0.5))
                            .frame(width: 8, height: 12)
                            .offset(y: -7)
                            .rotationEffect(.degrees(Double(i) * 72))
                    }
                    Circle()
                        .fill(Theme.petalPink)
                        .frame(width: 10, height: 10)
                    Image(systemName: "bouquet.fill")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.deepBranch)
                }
                .frame(width: 28, height: 28)
                
                Text("Bouquet")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.secondaryText)
            }
        }
    }
    
    func loadCurrentWeekEntries() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = weekday - 1
        
        guard let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today),
              let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            return
        }
        
        weekStart = startOfWeek
        
        let fetchRequest = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        fetchRequest.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfWeek as NSDate,
            endOfWeek as NSDate
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: true)]
        
        do {
            selectedWeekEntries = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching week entries: \(error)")
            selectedWeekEntries = []
        }
    }
}
