import CoreData
import Foundation

class PersistenceController {
    nonisolated(unsafe) static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        let model = NSManagedObjectModel()
        
        let entity = NSEntityDescription()
        entity.name = "MoodEntry"
        entity.managedObjectClassName = NSStringFromClass(MoodEntry.self)
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = false
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType
        dateAttribute.isOptional = false
        
        let flowerTypeAttribute = NSAttributeDescription()
        flowerTypeAttribute.name = "flowerType"
        flowerTypeAttribute.attributeType = .stringAttributeType
        flowerTypeAttribute.isOptional = false
        
        let moodAttribute = NSAttributeDescription()
        moodAttribute.name = "mood"
        moodAttribute.attributeType = .stringAttributeType
        moodAttribute.isOptional = false
        
        let entryTextAttribute = NSAttributeDescription()
        entryTextAttribute.name = "entryText"
        entryTextAttribute.attributeType = .stringAttributeType
        entryTextAttribute.isOptional = true
        
        entity.properties = [idAttribute, dateAttribute, flowerTypeAttribute, moodAttribute, entryTextAttribute]
        model.entities = [entity]
        
        container = NSPersistentContainer(name: "FloriLogModel", managedObjectModel: model)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error saving Core Data: \(nsError), \(nsError.userInfo)")
        }
    }
}
