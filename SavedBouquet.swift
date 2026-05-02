import Foundation

struct SavedBouquet: Codable, Identifiable {
    var id = UUID()
    let weekStart: Date
    let weekEnd: Date
    let flowerCounts: [String: Int] 
    let totalEntries: Int
    let savedDate: Date
    
    var weekDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: weekStart)) - \(formatter.string(from: weekEnd))"
    }
    
    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: weekStart)
    }
}
