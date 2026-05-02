import SwiftUI
import CoreData

struct BouquetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bouquetManager: BouquetManager
    
    let weekStart: Date
    
    @State private var isSaved = false
    @State private var weekEntries: [MoodEntry] = []
    
    struct ArrangedFlower: Identifiable {
        let id = UUID()
        let type: FlowerType
        let xOffset: CGFloat
        let yOffset: CGFloat
        let rotation: Double
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.sageGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 15) {
                        VStack(spacing: 8) {
                            Text(weekDateRange)
                                .font(.custom("Georgia", size: 18))
                                .foregroundColor(Theme.warmWhite.opacity(0.8))
                            
                            Text(bouquetStory.title)
                                .font(.custom("Georgia", size: 26))
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundColor(Theme.warmWhite)
                                .padding(.horizontal)
                        }
                        .padding(.top, 30)
                        
                        GeometryReader { geometry in
                            let center = geometry.size.width / 2
                            
                            ZStack {
                                ForEach(arrangedFlowers) { flower in
                                    Path { path in
                                        let stemStartX = center + (flower.xOffset * 0.3)
                                        let flowerCenterX = center + flower.xOffset
                                        let flowerCenterY = flower.yOffset + 190 + 28
                                        
                                        path.move(to: CGPoint(x: stemStartX, y: 180))
                                        path.addLine(to: CGPoint(x: flowerCenterX, y: flowerCenterY))
                                    }
                                    .stroke(Theme.sageDeep.opacity(0.7), lineWidth: 3)
                                }
                                
                                VictorianVase()
                                    .frame(width: 180, height: 220)
                                    .position(x: center, y: 270)
                                
                                ForEach(arrangedFlowers) { flower in
                                    FlowerView(type: flower.type, size: 42)
                                        .position(x: center + flower.xOffset, y: flower.yOffset + 190)
                                        .rotationEffect(.degrees(flower.rotation))
                                }
                            }
                        }
                        .frame(height: 420)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Your Week's Story")
                                .font(.custom("Georgia", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.warmWhite)
                            
                            Text(bouquetStory.description)
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Theme.warmWhite.opacity(0.85))
                                .lineSpacing(6)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(flowerCounts, id: \.flower) { item in
                                    HStack {
                                        FlowerView(type: item.flower, size: 32)
                                            .frame(width: 32, height: 42)
                                        Text("\(item.count)x \(item.flower.rawValue)")
                                            .font(.custom("Georgia", size: 15))
                                            .foregroundColor(Theme.warmWhite)
                                        Spacer()
                                        Text(item.flower.mood)
                                            .font(.custom("Georgia", size: 13))
                                            .italic()
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Theme.warmWhite.opacity(0.25))
                                            .cornerRadius(10)
                                            .foregroundColor(Theme.warmWhite)
                                    }
                                }
                            }
                            .padding()
                            .background(Theme.warmWhite.opacity(0.15))
                            .cornerRadius(14)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 10) {
                            Image(systemName: "quote.opening")
                                .font(.custom("Georgia", size: 10))
                                .foregroundColor(Theme.warmWhite.opacity(0.6))
                            
                            Text(bouquetStory.victorianQuote)
                                .font(.custom("Georgia", size: 14))
                                .italic()
                                .multilineTextAlignment(.center)
                                .foregroundColor(Theme.warmWhite.opacity(0.8))
                                .padding(.horizontal, 35)
                            
                            Image(systemName: "quote.closing")
                                .font(.custom("Georgia", size: 10))
                                .foregroundColor(Theme.warmWhite.opacity(0.6))
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Your Bouquet")
                        .font(.custom("Georgia", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.warmWhite)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        HapticManager.selection()
                        saveBouquet()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 14))
                            Text(isSaved ? "Saved" : "Save")
                                .font(.custom("Georgia", size: 15))
                        }
                        .foregroundColor(Theme.roseDust)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .cornerRadius(20)
                    }
                    .disabled(isSaved)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        HapticManager.selection()
                        dismiss()
                    }
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Theme.roseDust)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .cornerRadius(20)
                }
            }
        }
        .onAppear {
            loadWeekEntries()
        }
    }
    
    func loadWeekEntries() {
        let calendar = Calendar.current
        
        guard let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else {
            weekEntries = []
            return
        }
        
        let fetchRequest = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        fetchRequest.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            weekStart as NSDate,
            weekEnd as NSDate
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: true)]
        
        do {
            weekEntries = try viewContext.fetch(fetchRequest)
        } catch {
            print("❌ Error: \(error)")
            weekEntries = []
        }
    }
    
    var weekDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let calendar = Calendar.current
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) ?? weekStart
        return "\(formatter.string(from: weekStart)) - \(formatter.string(from: weekEnd))"
    }
    
    var flowerCounts: [(flower: FlowerType, count: Int)] {
        var counts: [FlowerType: Int] = [:]
        for entry in weekEntries {
            if let flower = entry.flower {
                counts[flower, default: 0] += 1
            }
        }
        return counts.map { ($0.key, $0.value) }.sorted { $0.count > $1.count }
    }
    
    var arrangedFlowers: [ArrangedFlower] {
        var arranged: [ArrangedFlower] = []
        
        let count = weekEntries.count
        guard count > 0 else { return arranged }
        
        if count == 1 {
            if let flower = weekEntries.first?.flower {
                arranged.append(ArrangedFlower(type: flower, xOffset: 0, yOffset: -80, rotation: 0))
            }
            return arranged
        }
        
        let radius: CGFloat = 85
        let totalAngle: Double = 130.0
        let angleStep = totalAngle / max(Double(count - 1), 1)
        let startAngle = -65.0
        
        for (index, entry) in weekEntries.enumerated() {
            guard let flower = entry.flower else { continue }
            
            let angle = startAngle + (Double(index) * angleStep)
            let radians = angle * .pi / 180
            
            let x = radius * CGFloat(sin(radians))
            let y = -radius * CGFloat(cos(radians)) - 60
            let rotation = angle * 0.1
            
            arranged.append(ArrangedFlower(type: flower, xOffset: x, yOffset: y, rotation: rotation))
        }
        
        return arranged
    }
    
    var bouquetStory: BouquetStory {
        let moodTypes = Set(weekEntries.compactMap { $0.flower })
        let entryCount = weekEntries.count
        
        if entryCount == 0 {
            return BouquetStory(
                title: "An Empty Vase",
                description: "This week holds potential, waiting to be filled with moments and emotions.",
                victorianQuote: "The anticipation of beauty is beauty itself."
            )
        } else if entryCount == 7 {
            return BouquetStory(
                title: "A Complete Bouquet",
                description: "You tended to your emotional garden every day this week.",
                victorianQuote: "Consistency in care yields the most beautiful blooms."
            )
        } else if moodTypes.contains(.yellowTulip) && moodTypes.count == 1 {
            return BouquetStory(
                title: "Sunshine Arrangement",
                description: "Your week bloomed with joy and happiness.",
                victorianQuote: "Happiness, like the sun, illuminates all it touches."
            )
        } else if moodTypes.contains(.lotusFlower) && weekEntries.count >= 4 {
            return BouquetStory(
                title: "Tranquil Waters",
                description: "Peace and serenity dominated your week.",
                victorianQuote: "In stillness, the soul finds its truest expression."
            )
        } else if moodTypes.count >= 4 {
            return BouquetStory(
                title: "The Rainbow Garden",
                description: "Your week was a rich tapestry of emotions.",
                victorianQuote: "Variety in the garden mirrors the complexity of the heart."
            )
        } else {
            return BouquetStory(
                title: "A Balanced Arrangement",
                description: "Your emotions ebbed and flowed naturally this week.",
                victorianQuote: "Harmony is found not in sameness, but in thoughtful contrast."
            )
        }
    }
    
    func saveBouquet() {
        let calendar = Calendar.current
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) ?? weekStart
        
        bouquetManager.saveBouquet(
            weekStart: weekStart,
            weekEnd: weekEnd,
            entries: weekEntries
        )
        
        HapticManager.success()
        isSaved = true
    }
}

struct BouquetStory {
    let title: String
    let description: String
    let victorianQuote: String
}
