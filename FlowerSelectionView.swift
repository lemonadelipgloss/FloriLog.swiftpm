import SwiftUI

struct FlowerSelectionView: View {
    @Binding var selectedFlower: FlowerType?
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.sageGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How are you feeling today?")
                            .font(.custom("Georgia", size: 24))
                            .foregroundColor(Theme.warmWhite)
                            .padding(.horizontal)
                            .padding(.top, 12)
                        
                        Text("Choose the flower that speaks to your heart")
                            .font(.custom("Georgia", size: 15))
                            .italic()
                            .foregroundColor(Theme.warmWhite.opacity(0.8))
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        
                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(FlowerType.allCases, id: \.self) { flower in
                                FlowerSelectionCard(
                                    flower: flower,
                                    isSelected: selectedFlower == flower
                                )
                                .onTapGesture {
                                    HapticManager.impact(.medium)
                                    selectedFlower = flower
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        dismiss()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pick Your Flower")
                        .font(.custom("Georgia", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.warmWhite)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        HapticManager.selection()
                        dismiss()
                    }
                    .foregroundColor(Theme.roseDust)
                }
            }
        }
    }
}

struct FlowerSelectionCard: View {
    let flower: FlowerType
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            FlowerView(type: flower, size: 75)
                .frame(height: 100)
                .shadow(
                    color: flower.petalColor.opacity(0.4),
                    radius: isSelected ? 14 : 5,
                    x: 0,
                    y: 4
                )
            
            Text(flower.mood)
                .font(.custom("Georgia", size: 18))
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? Theme.roseDust : Theme.warmWhite)
            
            Text(flower.rawValue)
                .font(.custom("Georgia", size: 12))
                .italic()
                .foregroundColor(isSelected ? Theme.roseDust : Theme.warmWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(isSelected ? Theme.warmWhite : Theme.warmWhite.opacity(0.2))
                .shadow(
                    color: isSelected ? flower.petalColor.opacity(0.3) : Color.clear,
                    radius: 12,
                    x: 0,
                    y: 6
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isSelected ? flower.petalColor : Theme.warmWhite.opacity(0.3), lineWidth: isSelected ? 2.5 : 1)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.65), value: isSelected)
    }
}
