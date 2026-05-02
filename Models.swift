import Foundation
import SwiftUI
import CoreData

enum FlowerType: String, CaseIterable {
    case yellowTulip = "Yellow Tulip"
    case purpleHyacinth = "Purple Hyacinth"
    case tigerLily = "Tiger Lily"
    case lotusFlower = "Lotus Flower"
    case chamomile = "Chamomile"
    
    var mood: String {
        switch self {
        case .yellowTulip: return "Happy"
        case .purpleHyacinth: return "Sad"
        case .tigerLily: return "Angry"
        case .lotusFlower: return "Calm"
        case .chamomile: return "Tired"
        }
    }
    
    var emoji: String {
        switch self {
        case .yellowTulip: return "🌷"
        case .purpleHyacinth: return "🪻"
        case .tigerLily: return "🌺"
        case .lotusFlower: return "🪷"
        case .chamomile: return "🌼"
        }
    }
    
    var color: Color {
        switch self {
        case .yellowTulip: return .yellow
        case .purpleHyacinth: return .purple
        case .tigerLily: return .orange
        case .lotusFlower: return .pink
        case .chamomile: return Color(red: 0.95, green: 0.95, blue: 0.7)
        }
    }
}

@objc(MoodEntry)
public class MoodEntry: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var flowerType: String
    @NSManaged public var mood: String
    @NSManaged public var entryText: String?
    
    var flower: FlowerType? {
        get {
            return FlowerType(rawValue: flowerType)
        }
        set {
            if let newValue = newValue {
                flowerType = newValue.rawValue
                mood = newValue.mood
            }
        }
    }
}

extension MoodEntry {
    static func create(
        date: Date,
        flower: FlowerType,
        entryText: String?,
        in context: NSManagedObjectContext
    ) -> MoodEntry {
        let entry = MoodEntry(context: context)
        entry.id = UUID()
        entry.date = date
        entry.flower = flower
        entry.entryText = entryText
        return entry
    }
    
    static func fetchEntry(for date: Date, in context: NSManagedObjectContext) -> MoodEntry? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<MoodEntry>(entityName: "MoodEntry")
        fetchRequest.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching entry: \(error)")
            return nil
        }
    }
}

extension MoodEntry {
    public override var description: String {
        return "MoodEntry(id: \(id), date: \(date), mood: \(mood))"
    }
}
