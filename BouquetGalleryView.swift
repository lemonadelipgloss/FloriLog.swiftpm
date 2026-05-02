import SwiftUI

struct BouquetGalleryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bouquetManager: BouquetManager
    
    @State private var selectedBouquet: SavedBouquet?
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.sageGradient.ignoresSafeArea()
                
                Group {
                    if bouquetManager.savedBouquets.isEmpty {
                        VStack(spacing: 22) {
                            ForgetMeNotView(size: 70, color: .blue)
                                .opacity(0.3)
                            
                            Text("No Saved Bouquets Yet")
                                .font(.custom("Georgia", size: 24))
                                .bold()
                                .foregroundColor(Theme.warmWhite)
                            
                            Text("Save your weekly bouquets to view them here")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Theme.warmWhite.opacity(0.75))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 45)
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(bouquetManager.savedBouquets) { bouquet in
                                    BouquetCard(bouquet: bouquet)
                                        .onTapGesture {
                                            HapticManager.selection()
                                            selectedBouquet = bouquet
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Bouquet Gallery")
                        .font(.custom("Georgia", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.warmWhite)
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
            .sheet(item: $selectedBouquet) { bouquet in
                SavedBouquetDetailViewWrapper(bouquet: bouquet, bouquetManager: bouquetManager)
            }
        }
    }
}

struct SavedBouquetDetailViewWrapper: View {
    let bouquet: SavedBouquet
    let bouquetManager: BouquetManager
    @Environment(\.dismiss) var dismiss
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            SavedBouquetDetailView(
                bouquet: bouquet,
                onDelete: {
                    showDeleteAlert = true
                },
                onClose: {
                    dismiss()
                }
            )
            
            if showDeleteAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .zIndex(998)
                    .onTapGesture {
                        showDeleteAlert = false
                    }
                
                VStack(spacing: 16) {
                    Text("Delete Bouquet")
                        .font(.custom("Georgia", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Theme.roseDust)
                    
                    Text("Are you sure you want to delete this saved bouquet?")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Theme.roseDust)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                    
                    HStack(spacing: 10) {
                        Button(action: {
                            showDeleteAlert = false
                        }) {
                            Text("Cancel")
                                .font(.custom("Georgia", size: 15))
                                .foregroundColor(Theme.roseDust)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Theme.warmWhite.opacity(0.5))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            bouquetManager.deleteBouquet(bouquet)
                            showDeleteAlert = false
                            dismiss()
                        }) {
                            Text("Delete")
                                .font(.custom("Georgia", size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Theme.roseDust)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Theme.sageLight)
                        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4)
                )
                .padding(.horizontal, 50)
                .frame(maxWidth: 400)
                .zIndex(999)
            }
        }
    }
}

struct BouquetCard: View {
    let bouquet: SavedBouquet
    
    var flowers: [(FlowerType, Int)] {
        bouquet.flowerCounts.compactMap { key, value in
            guard let flower = FlowerType(rawValue: key) else { return nil }
            return (flower, value)
        }.sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                HStack(spacing: 6) {
                    ForEach(flowers.prefix(3), id: \.0.rawValue) { flower, _ in
                        FlowerView(type: flower, size: 24)
                            .frame(height: 32)
                    }
                }
                .offset(y: -15)
                
                VictorianVaseShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.82, green: 0.75, blue: 0.65),
                                Color(red: 0.72, green: 0.62, blue: 0.50)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 60, height: 70)
                    .offset(y: 20)
            }
            .frame(height: 70)
            
            Text(bouquet.weekDateRange)
                .font(.custom("Georgia", size: 13))
                .bold()
                .foregroundColor(Theme.warmWhite)
            
            Text("\(bouquet.totalEntries) entries")
                .font(.custom("Georgia", size: 11))
                .foregroundColor(Theme.warmWhite.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Theme.warmWhite.opacity(0.2))
        )
    }
}

struct SavedBouquetDetailView: View {
    let bouquet: SavedBouquet
    let onDelete: () -> Void
    let onClose: () -> Void
    
    struct FlowerPosition: Identifiable {
        let id = UUID()
        let flower: FlowerType
        let xOffset: CGFloat
        let yOffset: CGFloat
        let rotation: Double
    }
    
    var flowers: [(FlowerType, Int)] {
        bouquet.flowerCounts.compactMap { key, value in
            guard let flower = FlowerType(rawValue: key) else { return nil }
            return (flower, value)
        }.sorted { $0.1 > $1.1 }
    }
    
    var flowerPositions: [FlowerPosition] {
        var positions: [FlowerPosition] = []
        
        if flowers.count == 1, let flower = flowers.first {
            positions.append(FlowerPosition(flower: flower.0, xOffset: 0, yOffset: -80, rotation: 0))
            return positions
        }
        
        let totalFlowers = flowers.reduce(0) { $0 + min($1.1, 3) }
        let radius: CGFloat = 85
        let totalAngle: Double = 130.0
        let angleStep = totalAngle / max(Double(totalFlowers - 1), 1)
        let startAngle = -65.0
        
        var currentIndex = 0
        for item in flowers {
            let flower = item.0
            let count = item.1
            let maxFlowers = min(count, 3)
            
            for _ in 0..<maxFlowers {
                let angle = startAngle + (Double(currentIndex) * angleStep)
                let radians = angle * .pi / 180
                
                let x = radius * CGFloat(sin(radians))
                let y = -radius * CGFloat(cos(radians)) - 60
                let rotation = angle * 0.1
                
                positions.append(FlowerPosition(flower: flower, xOffset: x, yOffset: y, rotation: rotation))
                currentIndex += 1
            }
        }
        
        return positions
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.sageGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 15) {
                        VStack(spacing: 8) {
                            Text(bouquet.weekDateRange)
                                .font(.custom("Georgia", size: 18))
                                .foregroundColor(Theme.warmWhite.opacity(0.8))
                            
                            Text("Saved Bouquet")
                                .font(.custom("Georgia", size: 24))
                                .bold()
                                .foregroundColor(Theme.warmWhite)
                        }
                        .padding(.top, 30)
                        
                        GeometryReader { geometry in
                            let center = geometry.size.width / 2
                            
                            ZStack {
                                ForEach(flowerPositions) { position in
                                    Path { path in
                                        let stemStartX = center + (position.xOffset * 0.3)
                                        let flowerCenterX = center + position.xOffset
                                        let flowerCenterY = position.yOffset + 190 + 28
                                        
                                        path.move(to: CGPoint(x: stemStartX, y: 180))
                                        path.addLine(to: CGPoint(x: flowerCenterX, y: flowerCenterY))
                                    }
                                    .stroke(Theme.sageDeep.opacity(0.7), lineWidth: 3)
                                }
                                
                                VictorianVase()
                                    .frame(width: 180, height: 220)
                                    .position(x: center, y: 270)
                                
                                ForEach(flowerPositions) { position in
                                    FlowerView(type: position.flower, size: 42)
                                        .position(x: center + position.xOffset, y: position.yOffset + 190)
                                        .rotationEffect(.degrees(position.rotation))
                                }
                            }
                        }
                        .frame(height: 420)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("This Week's Flowers")
                                .font(.custom("Georgia", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.warmWhite)
                            
                            ForEach(flowers, id: \.0.rawValue) { flower, count in
                                HStack {
                                    FlowerView(type: flower, size: 32)
                                        .frame(width: 32, height: 42)
                                    Text("\(count)x \(flower.rawValue)")
                                        .font(.custom("Georgia", size: 15))
                                        .foregroundColor(Theme.warmWhite)
                                    Spacer()
                                    Text(flower.mood)
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
                        .padding(.horizontal)
                        
                        Text("Saved on \(bouquet.savedDate, style: .date)")
                            .font(.custom("Georgia", size: 13))
                            .italic()
                            .foregroundColor(Theme.warmWhite.opacity(0.65))
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Saved Bouquet")
                        .font(.custom("Georgia", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.warmWhite)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        HapticManager.selection()
                        onClose()
                    }
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Theme.roseDust)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .cornerRadius(20)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        onDelete()
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.roseDust)
                            .padding(10)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}
