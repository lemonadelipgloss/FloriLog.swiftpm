import Foundation

class BouquetManager: ObservableObject {
    @Published var savedBouquets: [SavedBouquet] = []
    
    private let saveKey = "SavedBouquets"
    
    init() {
        loadBouquets()
    }
    
    func saveBouquet(weekStart: Date, weekEnd: Date, entries: [MoodEntry]) {
        var flowerCounts: [String: Int] = [:]
        for entry in entries {
            if let flower = entry.flower {
                flowerCounts[flower.rawValue, default: 0] += 1
            }
        }
        
        if let existingIndex = savedBouquets.firstIndex(where: {
            Calendar.current.isDate($0.weekStart, inSameDayAs: weekStart)
        }) {
            savedBouquets[existingIndex] = SavedBouquet(
                weekStart: weekStart,
                weekEnd: weekEnd,
                flowerCounts: flowerCounts,
                totalEntries: entries.count,
                savedDate: Date()
            )
        } else {
            let newBouquet = SavedBouquet(
                weekStart: weekStart,
                weekEnd: weekEnd,
                flowerCounts: flowerCounts,
                totalEntries: entries.count,
                savedDate: Date()
            )
            savedBouquets.insert(newBouquet, at: 0) 
        }
        
        saveToDisk()
    }
    
    func deleteBouquet(_ bouquet: SavedBouquet) {
        savedBouquets.removeAll { $0.id == bouquet.id }
        saveToDisk()
    }
    
    private func saveToDisk() {
        if let encoded = try? JSONEncoder().encode(savedBouquets) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadBouquets() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([SavedBouquet].self, from: data) {
            savedBouquets = decoded
        }
    }
}
