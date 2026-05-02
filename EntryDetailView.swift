import SwiftUI
import CoreData

struct EntryDetailView: View {
    @State var entry: MoodEntry
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    @State private var editedText: String = ""
    @State private var showDeleteAlert = false
    
    @State private var flowerType: FlowerType?
    @State private var entryDate: Date
    @State private var entryTextDisplay: String?
    
    init(entry: MoodEntry) {
        _entry = State(initialValue: entry)
        _entryDate = State(initialValue: entry.date)
        _flowerType = State(initialValue: entry.flower)
        _entryTextDisplay = State(initialValue: entry.entryText)
    }
    
    var body: some View {
        ZStack {
            Theme.sageGradient.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    if let flower = flowerType {
                        VStack(spacing: 12) {
                            FlowerView(type: flower, size: 85)
                                .frame(height: 110)
                                .shadow(color: flower.petalColor.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Text(flower.mood)
                                .font(.custom("Georgia", size: 24))
                                .bold()
                                .foregroundColor(Theme.warmWhite)
                            
                            Text(flower.rawValue)
                                .font(.custom("Georgia", size: 16))
                                .italic()
                                .foregroundColor(Theme.warmWhite.opacity(0.75))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 35)
                        .background(flower.petalColor.opacity(0.2))
                        .cornerRadius(18)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.custom("Georgia", size: 13))
                            .foregroundColor(Theme.warmWhite.opacity(0.7))
                        
                        Text(entryDate, style: .date)
                            .font(.custom("Georgia", size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.warmWhite)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Journal Entry")
                                .font(.custom("Georgia", size: 13))
                                .foregroundColor(Theme.warmWhite.opacity(0.7))
                            
                            Spacer()
                            
                            if !isEditing {
                                Button("Edit") {
                                    HapticManager.selection()
                                    editedText = entryTextDisplay ?? ""
                                    isEditing = true
                                }
                                .font(.custom("Georgia", size: 13))
                                .foregroundColor(Theme.roseDust)
                            }
                        }
                        
                        if isEditing {
                            TextEditor(text: $editedText)
                                .frame(minHeight: 160)
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Theme.roseDust)
                                .padding(8)
                                .background(Theme.warmWhite)
                                .cornerRadius(10)
                            
                            HStack {
                                Button("Cancel") {
                                    HapticManager.selection()
                                    isEditing = false
                                }
                                .font(.custom("Georgia", size: 15))
                                .foregroundColor(Theme.roseDust)
                                
                                Spacer()
                                
                                Button("Save") {
                                    HapticManager.impact(.medium)
                                    saveEdit()
                                }
                                .font(.custom("Georgia", size: 15))
                                .bold()
                                .foregroundColor(Theme.roseDust)
                            }
                        } else {
                            Text(entryTextDisplay ?? "No entry written")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(
                                    entryTextDisplay == nil ?
                                    Theme.warmWhite.opacity(0.5) :
                                    Theme.warmWhite
                                )
                                .italic(entryTextDisplay == nil)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            
            if showDeleteAlert {
                CustomAlertView(
                    title: "Delete Entry",
                    message: "Are you sure you want to delete this entry?",
                    primaryButtonText: "Delete",
                    secondaryButtonText: "Cancel",
                    primaryAction: {
                        deleteEntry()
                    },
                    secondaryAction: {
                        showDeleteAlert = false
                    }
                )
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Entry Details")
                    .font(.custom("Georgia", size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.warmWhite)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(Theme.roseDust)
                }
            }
        }
    }
    
    private func saveEdit() {
        entry.entryText = editedText
        entryTextDisplay = editedText
        
        do {
            try viewContext.save()
            isEditing = false
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    private func deleteEntry() {
        let entryToDelete = entry
        dismiss()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewContext.delete(entryToDelete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting: \(error)")
            }
        }
    }
}

