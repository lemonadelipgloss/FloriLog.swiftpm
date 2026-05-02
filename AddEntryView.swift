import SwiftUI
import CoreData

struct AddEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedFlower: FlowerType?
    @State private var entryText: String = ""
    @State private var selectedDate = Date()
    @State private var showFlowerPicker = false
    @State private var showAlert = false
    @State private var showBloomAnimation = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Theme.sageGradient.ignoresSafeArea()
                    
                    Form {
                        Section(header: Text("Date")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(Theme.secondaryText)
                        ) {
                            DatePicker("Entry Date", selection: $selectedDate, displayedComponents: .date)
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Theme.roseDust)
                        }
                        .listRowBackground(Theme.warmWhite.opacity(0.7))
                        
                        Section(header: Text("Mood")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(Theme.secondaryText)
                        ) {
                            if let flower = selectedFlower {
                                HStack(spacing: 16) {
                                    FlowerView(type: flower, size: 50)
                                        .frame(height: 66)
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(flower.mood)
                                            .font(.custom("Georgia", size: 18))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Theme.roseDust)
                                        Text(flower.rawValue)
                                            .font(.custom("Georgia", size: 14))
                                            .italic()
                                            .foregroundColor(Theme.roseDust)
                                    }
                                    Spacer()
                                    Button("Change") {
                                        HapticManager.selection()
                                        showFlowerPicker = true
                                    }
                                    .font(.custom("Georgia", size: 15))
                                    .foregroundColor(Theme.roseDust)
                                }
                                .padding(.vertical, 8)
                            } else {
                                Button(action: {
                                    HapticManager.selection()
                                    showFlowerPicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "leaf.fill")
                                            .foregroundColor(Theme.sageMid)
                                        Text("Select Your Flower")
                                            .font(.custom("Georgia", size: 17))
                                            .foregroundColor(Theme.roseDust)
                                            .foregroundColor(Theme.deepBranch)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12))
                                    }
                                }
                            }
                        }
                        .listRowBackground(Theme.warmWhite.opacity(0.7))
                        
                        Section(header: Text("Journal Entry (Optional)")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(Theme.secondaryText)
                        ) {
                            TextEditor(text: $entryText)
                                .frame(minHeight: 160)
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Theme.roseDust)
                        }
                        .listRowBackground(Theme.warmWhite.opacity(0.7))
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("New Entry")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("New Entry")
                                .font(.custom("Georgia", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.warmWhite)
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                HapticManager.selection()
                                dismiss()
                            }
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Theme.roseDust)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                saveEntry()
                            }
                            .font(.custom("Georgia", size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.roseDust)
                            .foregroundColor(selectedFlower != nil ? Theme.roseDust : Theme.warmWhite.opacity(0.5))
                            .disabled(selectedFlower == nil)
                        }
                    }
                    .sheet(isPresented: $showFlowerPicker) {
                        FlowerSelectionView(selectedFlower: $selectedFlower)
                    }
                
                    .overlay(
                        Group {
                            if showAlert {
                                CustomAlertView(
                                    title: "Entry Exists",
                                    message: "An entry already exists for this date. Replace it?",
                                    primaryButtonText: "Replace",
                                    secondaryButtonText: "Cancel",
                                    primaryAction: {
                                        saveEntry(replace: true)
                                        showAlert = false
                                    },
                                    secondaryAction: {
                                        showAlert = false
                                    }
                                )
                            }
                        }
                    )
                }
            }
            
            if showBloomAnimation, let flower = selectedFlower {
                BloomAnimationView(
                    flower: flower,
                    isAnimating: $showBloomAnimation
                )
                .onDisappear {
                    dismiss()
                }
            }
        }
    }
    
    func saveEntry(replace: Bool = false) {
        guard let flower = selectedFlower else { return }
        
        if let existingEntry = MoodEntry.fetchEntry(for: selectedDate, in: viewContext) {
            if !replace {
                showAlert = true
                return
            } else {
                viewContext.delete(existingEntry)
            }
        }
        
        _ = MoodEntry.create(
            date: selectedDate,
            flower: flower,
            entryText: entryText.isEmpty ? nil : entryText,
            in: viewContext
        )
        
        do {
            try viewContext.save()
            HapticManager.success()
            withAnimation {
                showBloomAnimation = true
            }
        } catch {
            print("Error saving: \(error)")
        }
    }
}

struct CustomAlertView: View {
    let title: String
    let message: String
    let primaryButtonText: String
    let secondaryButtonText: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    secondaryAction()
                }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.custom("Georgia", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Theme.roseDust)
                
                Text(message)
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(Theme.roseDust)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                HStack(spacing: 12) {
                    Button(action: secondaryAction) {
                        Text(secondaryButtonText)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Theme.roseDust)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.warmWhite.opacity(0.5))
                            .cornerRadius(12)
                    }
                    
                    Button(action: primaryAction) {
                        Text(primaryButtonText)
                            .font(.custom("Georgia", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.roseDust)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.sageLight)
                    .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 5)
            )
            .padding(.horizontal, 40)
        }
    }
}
