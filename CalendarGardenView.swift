import SwiftUI
import CoreData

struct CalendarGardenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var bouquetManager: BouquetManager
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: false)],
        animation: .default
    ) private var allEntries: FetchedResults<MoodEntry>
    
    @State private var selectedMonth = Date()
    @State private var showAddEntry = false
    @State private var selectedEntry: MoodEntry?
    @State private var showAbout = false
    @State private var showBouquet = false
    @State private var selectedWeekEntries: [MoodEntry] = []
    @State private var bouquetWeekStart = Date()
    @State private var showBouquetGallery = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.sageGradient.ignoresSafeArea()
                
                GeometryReader { geo in
                    let positions: [(x: CGFloat, y: CGFloat, rotation: Double)] = [
                        (0.09, 0.12, -8),  (0.91, 0.18, 6),   (0.14, 0.22, -4), (0.86, 0.26, 10),
                        (0.10, 0.34, -2),  (0.90, 0.38, 7),   (0.16, 0.44, -6), (0.84, 0.48, 5),
                        (0.08, 0.56, -9),  (0.92, 0.60, 8),   (0.18, 0.66, -3), (0.82, 0.70, 4),
                        (0.12, 0.76, -7),  (0.88, 0.80, 9),   (0.20, 0.84, -5), (0.80, 0.88, 3),
                        (0.26, 0.16, -1),  (0.74, 0.32, 2),   (0.28, 0.68, -2), (0.72, 0.84, 1)
                    ]
                    let colors: [ForgetMeNotView.ForgetMeNotColor] = [.blue, .pink, .white, .blue, .pink, .white, .blue, .pink, .blue, .white, .pink, .blue, .blue, .pink, .white, .blue, .white, .pink, .blue, .pink]

                    ForEach(0..<positions.count, id: \.self) { i in
                        let p = positions[i]
                        ZStack {
                            ForgetMeNotView(size: 26, color: colors[i])
                            if i % 3 == 0 {
                                SimpleLeaf(size: 14)
                                    .rotationEffect(.degrees([36, 48, 60, 42, 54, 66, 38].randomElement() ?? 48))
                                    .offset(x: -8, y: 6)
                            }
                        }
                        .opacity(0.25)
                        .position(x: p.x * geo.size.width, y: p.y * geo.size.height)
                        .rotationEffect(.degrees(p.rotation))
                    }
                }
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            HStack(spacing: 20) {
                                Button(action: {
                                    HapticManager.selection()
                                    previousMonth()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(Theme.warmWhite)
                                        .frame(width: 50, height: 50)
                                        .background(Theme.warmWhite.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 4) {
                                    Text(monthString)
                                        .font(.custom("Georgia", size: 26))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Theme.warmWhite)
                                    
                                    Text(yearString)
                                        .font(.custom("Georgia", size: 16))
                                        .foregroundColor(Theme.warmWhite.opacity(0.75))
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    HapticManager.selection()
                                    nextMonth()
                                }) {
                                    Image(systemName: "chevron.right")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(Theme.warmWhite)
                                        .frame(width: 50, height: 50)
                                        .background(Theme.warmWhite.opacity(0.2))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 20)
                            .frame(maxWidth: 900)
                            
                            HStack {
                                Rectangle()
                                    .fill(Theme.warmWhite.opacity(0.3))
                                    .frame(height: 1)
                                Text("✿")
                                    .font(.custom("Georgia", size: 12))
                                    .foregroundColor(Theme.warmWhite.opacity(0.6))
                                Rectangle()
                                    .fill(Theme.warmWhite.opacity(0.3))
                                    .frame(height: 1)
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .frame(maxWidth: 900)
                            
                            HStack {
                                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                                    Text(day)
                                        .font(.custom("Georgia", size: 16))
                                        .foregroundColor(Theme.warmWhite.opacity(0.7))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 8)
                            .frame(maxWidth: 900)
                            
                            let days = generateDaysInMonth(for: selectedMonth)
                            
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible()), count: 7),
                                spacing: 18
                            ) {
                                ForEach(days.indices, id: \.self) { index in
                                    if let date = days[index] {
                                        DayCell(
                                            date: date,
                                            entry: getEntry(for: date),
                                            isCurrentMonth: Calendar.current.isDate(
                                                date,
                                                equalTo: selectedMonth,
                                                toGranularity: .month
                                            ),
                                            isToday: Calendar.current.isDateInToday(date)
                                        )
                                        .onTapGesture {
                                            HapticManager.selection()
                                            if let entry = getEntry(for: date) {
                                                selectedEntry = entry
                                            }
                                        }
                                    } else {
                                        Color.clear.frame(height: 85)
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 15)
                            .frame(maxWidth: 900)
                            .id(allEntries.count)
                            
                            Spacer(minLength: 120)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        FlowerNavButton(icon: "info.circle.fill", label: "About", color: Theme.roseDust) {
                            HapticManager.selection()
                            showAbout = true
                        }
                        
                        Spacer()
                        
                        FlowerNavButton(icon: "calendar", label: "Calendar", color: Theme.goldenYellow) {
                            HapticManager.selection()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            HapticManager.impact(.medium)
                            showAddEntry = true
                        }) {
                            ZStack {
                                ForEach(0..<6) { i in
                                    Ellipse()
                                        .fill(Theme.petalPink)
                                        .frame(width: 26, height: 40)
                                        .offset(y: -24)
                                        .rotationEffect(.degrees(Double(i) * 60))
                                }
                                Circle()
                                    .fill(Theme.roseDust)
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 70, height: 70)
                            .shadow(color: Theme.petalPink.opacity(0.4), radius: 10, x: 0, y: 4)
                        }
                        .offset(y: -15)
                        
                        Spacer()
                        
                        FlowerNavButton(icon: "leaf.fill", label: "Bouquet", color: Theme.softOrange) {
                            HapticManager.selection()
                            loadCurrentWeekEntries()
                            showBouquet = true
                        }
                        
                        Spacer()
                        
                        FlowerNavButton(icon: "square.grid.2x2.fill", label: "Gallery", color: Theme.lavender) {
                            HapticManager.selection()
                            showBouquetGallery = true
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Theme.warmWhite.opacity(0.15))
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddEntry) {
                AddEntryView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(item: $selectedEntry) { entry in
                NavigationView {
                    EntryDetailView(entry: entry)
                        .environment(\.managedObjectContext, viewContext)
                }
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
            .sheet(isPresented: $showBouquet) {
                BouquetView(

                    weekStart: bouquetWeekStart
                )
                .environmentObject(bouquetManager)
            }
            .sheet(isPresented: $showBouquetGallery) {
                BouquetGalleryView()
                    .environmentObject(bouquetManager)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func loadCurrentWeekEntries() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = weekday - 1
        
        guard let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today),
              let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            return
        }
        
        bouquetWeekStart = startOfWeek
        
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
    
    var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: selectedMonth)
    }
    
    var yearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: selectedMonth)
    }
    
    func getEntry(for date: Date) -> MoodEntry? {
        let calendar = Calendar.current
        return allEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: date)
        }
    }
    
    func previousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }
    
    func nextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }
    
    func generateDaysInMonth(for date: Date) -> [Date?] {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: date) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        guard let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count else { return [] }
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        for day in 1...daysInMonth {
            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: interval.start) {
                days.append(dayDate)
            }
        }
        return days
    }
}

struct FlowerNavButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    ForEach(0..<5) { i in
                        Ellipse()
                            .fill(color.opacity(0.6))
                            .frame(width: 16, height: 24)
                            .offset(y: -14)
                            .rotationEffect(.degrees(Double(i) * 72))
                    }
                    Circle()
                        .fill(color)
                        .frame(width: 18, height: 18)
                    
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 48, height: 48)
                
                Text(label)
                    .font(.custom("Georgia", size: 11))
                    .foregroundColor(Theme.roseDust)
            }
        }
    }
}

struct DayCell: View {
    let date: Date
    let entry: MoodEntry?
    let isCurrentMonth: Bool
    let isToday: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.custom("Georgia", size: 15))
                .foregroundColor(
                    isToday ? Theme.roseDust :
                    isCurrentMonth ? Theme.warmWhite : Theme.warmWhite.opacity(0.3)
                )
                .fontWeight(isToday ? .bold : .regular)
            
            if let entry = entry, let flower = entry.flower {
                FlowerView(type: flower, size: 44)
                    .frame(height: 56)
            } else {
                Circle()
                    .fill(Theme.warmWhite.opacity(isCurrentMonth ? 0.2 : 0.05))
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 85)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    entry != nil ?
                    Theme.warmWhite.opacity(0.18) :
                    (isToday ? Theme.warmWhite.opacity(0.12) : Color.clear)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isToday ? Theme.warmWhite.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}

let monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}()
