import SwiftUI

struct BloomAnimationView: View {
    let flower: FlowerType
    @Binding var isAnimating: Bool
    
    @State private var petalScales: [CGFloat] = Array(repeating: 0, count: 8)
    @State private var petalOpacities: [Double] = Array(repeating: 0, count: 8)
    @State private var stemHeight: CGFloat = 0
    @State private var centerScale: CGFloat = 0
    @State private var showSparkles: Bool = false
    @State private var overallScale: CGFloat = 0
    @State private var flowerScale: CGFloat = 0
    
    var body: some View {
        ZStack {
            if isAnimating {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isAnimating = false
                    }
                
                VStack(spacing: 20) {
                    if showSparkles {
                        SparklesView()
                            .frame(width: 200, height: 200)
                            .transition(.opacity)
                    }
                    
                    ZStack {
                        ForEach(0..<8) { i in
                            BloomPetal(
                                color: flower.petalColor,
                                index: i,
                                total: 8
                            )
                            .scaleEffect(petalScales[i])
                            .opacity(petalOpacities[i])
                        }
                        
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(red: 0.35, green: 0.55, blue: 0.30))
                                .frame(width: 6, height: stemHeight)
                        }
                        .frame(height: 120)
                        
                        FlowerView(type: flower, size: 50)
                            .scaleEffect(flowerScale)
                    }
                    .frame(width: 160, height: 160)
                    
                    VStack(spacing: 8) {
                        Text("Entry Saved")
                            .font(.custom("Georgia", size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.deepBranch)
                        
                        Text("\(flower.mood) · \(flower.rawValue)")
                            .font(.custom("Georgia", size: 15))
                            .italic()
                            .foregroundColor(Theme.secondaryText)
                    }
                    .scaleEffect(overallScale)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Theme.warmWhite.opacity(0.95))
                            .shadow(color: flower.petalColor.opacity(0.3), radius: 10)
                    )
                }
                .scaleEffect(overallScale)
                .onAppear {
                    startBloomAnimation()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isAnimating)
    }
    
    func startBloomAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            overallScale = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
            stemHeight = 80
        }
        
        for i in 0..<8 {
            let delay = 0.4 + Double(i) * 0.12
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(delay)) {
                petalScales[i] = 1.0
                petalOpacities[i] = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                HapticManager.impact(.light)
            }
        }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5).delay(1.4)) {
            flowerScale = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSparkles = true
            }
            HapticManager.success()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                isAnimating = false
            }
        }
    }
}

struct BloomPetal: View {
    let color: Color
    let index: Int
    let total: Int
    
    var angle: Double {
        Double(index) / Double(total) * 360
    }
    
    var body: some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [color, color.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 22, height: 52)
            .offset(y: -38)
            .rotationEffect(.degrees(angle))
            .overlay(
                Ellipse()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 10, height: 24)
                    .offset(y: -38)
                    .rotationEffect(.degrees(angle))
            )
    }
}

struct SparklesView: View {
    @State private var animate = false
    
    let positions: [(CGFloat, CGFloat)] = [
        (-70, -60), (60, -70), (-50, 50),
        (70, 40), (0, -90), (-80, 10),
        (80, -20), (30, 80), (-30, -80)
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<positions.count, id: \.self) { i in
                Text(i % 2 == 0 ? "✦" : "✿")
                    .font(.custom("Georgia", size: CGFloat.random(in: 10...18)))
                    .foregroundColor([
                        Theme.goldenYellow,
                        Theme.petalPink,
                        Theme.lavender,
                        Theme.sageMid,
                        Theme.softOrange
                    ][i % 5])
                    .offset(
                        x: positions[i].0 * (animate ? 1.3 : 0.8),
                        y: positions[i].1 * (animate ? 1.3 : 0.8)
                    )
                    .opacity(animate ? 0 : 1)
                    .scaleEffect(animate ? 1.5 : 1.0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                animate = true
            }
        }
    }
}

extension FlowerType {
    var petalColor: Color {
        switch self {
        case .yellowTulip: return Color(red: 0.98, green: 0.85, blue: 0.20)
        case .purpleHyacinth: return Color(red: 0.65, green: 0.45, blue: 0.85)
        case .tigerLily: return Color(red: 0.95, green: 0.50, blue: 0.15)
        case .lotusFlower: return Color(red: 0.95, green: 0.65, blue: 0.75)
        case .chamomile: return Color.white
        }
    }
    
    var centerColor: Color {
        switch self {
        case .yellowTulip: return Color(red: 0.90, green: 0.65, blue: 0.10)
        case .purpleHyacinth: return Color(red: 0.45, green: 0.25, blue: 0.65)
        case .tigerLily: return Color(red: 0.75, green: 0.30, blue: 0.08)
        case .lotusFlower: return Color(red: 0.98, green: 0.85, blue: 0.40)
        case .chamomile: return Color(red: 0.95, green: 0.82, blue: 0.25)
        }
    }
}
