import SwiftUI

// MARK: - Yellow Tulip (Happy)
struct TulipView: View {
    var size: CGFloat = 60
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.35, green: 0.55, blue: 0.30))
                .frame(width: size * 0.08, height: size * 0.50)
                .offset(y: size * 0.40)
            
            Ellipse()
                .fill(Color(red: 0.40, green: 0.60, blue: 0.35))
                .frame(width: size * 0.20, height: size * 0.35)
                .rotationEffect(.degrees(-35))
                .offset(x: size * 0.15, y: size * 0.30)
            
            Ellipse()
                .fill(Color(red: 0.98, green: 0.85, blue: 0.20))
                .frame(width: size * 0.32, height: size * 0.55)
                .offset(y: -size * 0.08)
            
            Ellipse()
                .fill(Color(red: 1.00, green: 0.88, blue: 0.25))
                .frame(width: size * 0.30, height: size * 0.52)
                .rotationEffect(.degrees(-18))
                .offset(x: -size * 0.16, y: -size * 0.06)
            
            Ellipse()
                .fill(Color(red: 1.00, green: 0.88, blue: 0.25))
                .frame(width: size * 0.30, height: size * 0.52)
                .rotationEffect(.degrees(18))
                .offset(x: size * 0.16, y: -size * 0.06)
            
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.4), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.18, height: size * 0.35)
                .offset(x: -size * 0.08, y: -size * 0.18)
        }
        .frame(width: size, height: size * 1.4)
    }
}

// MARK: - Purple Hyacinth (Sad)
struct HyacinthView: View {
    var size: CGFloat = 60
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color(red: 0.38, green: 0.55, blue: 0.35))
                .frame(width: size * 0.09, height: size * 0.65)
                .offset(y: size * 0.35)
            
            Ellipse()
                .fill(Color(red: 0.65, green: 0.52, blue: 0.42))
                .frame(width: size * 0.28, height: size * 0.32)
                .offset(y: size * 0.58)
            
            ForEach(0..<2) { i in
                Ellipse()
                    .fill(Color(red: 0.40, green: 0.58, blue: 0.38))
                    .frame(width: size * 0.12, height: size * 0.50)
                    .rotationEffect(.degrees(i == 0 ? -25 : 25))
                    .offset(
                        x: i == 0 ? -size * 0.18 : size * 0.18,
                        y: size * 0.45
                    )
            }
            
            VStack(spacing: -size * 0.02) {
                HyacinthFloret(
                    color: Color(red: 0.50, green: 0.35, blue: 0.70),
                    size: size * 0.12
                )
                
                ForEach(0..<5) { row in
                    HStack(spacing: size * 0.02) {
                        ForEach(0..<3) { _ in
                            HyacinthFloret(
                                color: Color(red: 0.50 + Double(row) * 0.04, green: 0.35, blue: 0.70),
                                size: size * 0.12
                            )
                        }
                    }
                    .offset(y: CGFloat(row) * size * 0.08)
                }
            }
            .offset(y: -size * 0.20)
        }
        .frame(width: size, height: size * 1.6)
    }
}

struct HyacinthFloret: View {
    let color: Color
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<6) { i in
                Ellipse()
                    .fill(color)
                    .frame(width: size * 0.4, height: size * 0.7)
                    .offset(y: -size * 0.25)
                    .rotationEffect(.degrees(Double(i) * 60))
            }
            Circle()
                .fill(Color(red: 0.35, green: 0.20, blue: 0.55))
                .frame(width: size * 0.35, height: size * 0.35)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Tiger Lily (Angry)
struct TigerLilyView: View {
    var size: CGFloat = 60
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.35, green: 0.52, blue: 0.30))
                .frame(width: size * 0.08, height: size * 0.52)
                .offset(y: size * 0.40)
            
            ForEach(0..<2) { i in
                Ellipse()
                    .fill(Color(red: 0.38, green: 0.56, blue: 0.32))
                    .frame(width: size * 0.10, height: size * 0.32)
                    .rotationEffect(.degrees(i == 0 ? -40 : 40))
                    .offset(
                        x: i == 0 ? -size * 0.14 : size * 0.14,
                        y: size * 0.28
                    )
            }
            
            ForEach(0..<6) { i in
                TigerLilyPetal()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.98, green: 0.65, blue: 0.20),
                                Color(red: 0.95, green: 0.50, blue: 0.15)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 0.24, height: size * 0.58)
                    .overlay(
                        VStack(spacing: size * 0.05) {
                            ForEach(0..<4) { spot in
                                Circle()
                                    .fill(Color(red: 0.25, green: 0.10, blue: 0.05))
                                    .frame(width: size * 0.04, height: size * 0.04)
                                    .offset(
                                        x: CGFloat.random(in: -size * 0.06...size * 0.06),
                                        y: CGFloat(spot) * size * 0.08 - size * 0.12
                                    )
                            }
                        }
                    )
                    .rotationEffect(.degrees(Double(i) * 60))
                    .offset(y: -size * 0.10)
            }
            
            ForEach(0..<6) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(red: 0.55, green: 0.35, blue: 0.15))
                    .frame(width: 2, height: size * 0.22)
                    .overlay(
                        Circle()
                            .fill(Color(red: 0.45, green: 0.25, blue: 0.10))
                            .frame(width: size * 0.06, height: size * 0.06)
                            .offset(y: -size * 0.13)
                    )
                    .offset(y: -size * 0.10)
                    .rotationEffect(.degrees(Double(i) * 60 + 30))
            }
        }
        .frame(width: size, height: size * 1.4)
    }
}

struct TigerLilyPetal: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: w * 0.5, y: h))
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: 0),
            control1: CGPoint(x: w * 0.0, y: h * 0.7),
            control2: CGPoint(x: w * 0.15, y: h * 0.15)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control1: CGPoint(x: w * 0.85, y: h * 0.15),
            control2: CGPoint(x: w * 1.0, y: h * 0.7)
        )
        return path
    }
}

// MARK: - Lotus (Calm)
struct LotusView: View {
    var size: CGFloat = 60
    
    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.42, green: 0.62, blue: 0.45))
                .frame(width: size * 0.85, height: size * 0.22)
                .offset(x: -size * 0.15, y: size * 0.45)
            
            Path { path in
                path.move(to: CGPoint(x: size * 0.20, y: size * 0.45))
                path.addLine(to: CGPoint(x: size * 0.20, y: size * 0.52))
            }
            .stroke(Color(red: 0.35, green: 0.55, blue: 0.38), lineWidth: 2)
            
            ForEach(0..<8) { i in
                LotusPetal()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.98, green: 0.80, blue: 0.85),
                                Color(red: 0.95, green: 0.70, blue: 0.78)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 0.28, height: size * 0.58)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .offset(y: size * 0.00)
            }
            
            ForEach(0..<6) { i in
                LotusPetal()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.96, green: 0.68, blue: 0.76),
                                Color(red: 0.93, green: 0.58, blue: 0.68)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 0.20, height: size * 0.46)
                    .rotationEffect(.degrees(Double(i) * 60 + 15))
                    .offset(y: -size * 0.06)
            }
            
            ForEach(0..<5) { i in
                LotusPetal()
                    .fill(Color(red: 0.92, green: 0.60, blue: 0.70))
                    .frame(width: size * 0.15, height: size * 0.36)
                    .rotationEffect(.degrees(Double(i) * 72 + 8))
                    .offset(y: -size * 0.10)
            }
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.00, green: 0.92, blue: 0.50),
                            Color(red: 0.95, green: 0.80, blue: 0.30)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.14
                    )
                )
                .frame(width: size * 0.22, height: size * 0.22)
                .offset(y: -size * 0.08)
            
            ForEach(0..<8) { i in
                Circle()
                    .fill(Color(red: 0.70, green: 0.52, blue: 0.20))
                    .frame(width: size * 0.035, height: size * 0.035)
                    .offset(
                        x: CGFloat(cos(Double(i) * 45 * .pi / 180)) * size * 0.07,
                        y: CGFloat(sin(Double(i) * 45 * .pi / 180)) * size * 0.07 - size * 0.08
                    )
            }
        }
        .frame(width: size, height: size * 1.4)
    }
}

struct LotusPetal: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: w * 0.5, y: h))
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: 0),
            control1: CGPoint(x: w * 0.08, y: h * 0.70),
            control2: CGPoint(x: w * 0.22, y: h * 0.08)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control1: CGPoint(x: w * 0.78, y: h * 0.08),
            control2: CGPoint(x: w * 0.92, y: h * 0.70)
        )
        return path
    }
}

// MARK: - Chamomile (Tired)
struct ChamomileView: View {
    var size: CGFloat = 60
    var color: Color = Color.white
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.35, green: 0.55, blue: 0.30))
                .frame(width: size * 0.07, height: size * 0.50)
                .offset(y: size * 0.38)

            ForEach(0..<3) { i in
                Ellipse()
                    .fill(Color(red: 0.38, green: 0.58, blue: 0.32))
                    .frame(width: size * 0.10, height: size * 0.24)
                    .rotationEffect(.degrees(Double(i) * 40 - 40))
                    .offset(
                        x: CGFloat(i - 1) * size * 0.12,
                        y: size * 0.22
                    )
            }
            

            ForEach(0..<16) { i in
                Ellipse()
                    .fill(color)
                    .frame(width: size * 0.10, height: size * 0.38)
                    .offset(y: -size * 0.22)
                    .rotationEffect(.degrees(Double(i) * 22.5))
            }
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.98, green: 0.90, blue: 0.30),
                            Color(red: 0.85, green: 0.68, blue: 0.15)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.18
                    )
                )
                .frame(width: size * 0.30, height: size * 0.30)
                .offset(y: -size * 0.08)
            
            ForEach(0..<8) { i in
                Circle()
                    .fill(Color(red: 0.70, green: 0.50, blue: 0.10).opacity(0.6))
                    .frame(width: size * 0.04, height: size * 0.04)
                    .offset(
                        x: CGFloat(cos(Double(i) * 45 * .pi / 180)) * size * 0.09,
                        y: CGFloat(sin(Double(i) * 45 * .pi / 180)) * size * 0.09 - size * 0.08
                    )
            }
        }
        .frame(width: size, height: size * 1.3)
    }
}

// MARK: - Forget-Me-Not
struct ForgetMeNotView: View {
    var size: CGFloat = 20
    var color: ForgetMeNotColor = .blue
    
    enum ForgetMeNotColor {
        case blue, pink, white
        
        var petalColor: Color {
            switch self {
            case .blue: return Color(red: 0.40, green: 0.55, blue: 0.95)
            case .pink: return Color(red: 0.98, green: 0.75, blue: 0.85)
            case .white: return Color.white
            }
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<5) { i in
                Circle()
                    .fill(color.petalColor)
                    .frame(width: size * 0.45, height: size * 0.45)
                    .offset(y: -size * 0.28)
                    .rotationEffect(.degrees(Double(i) * 72))
            }
            Circle()
                .fill(Color(red: 1.00, green: 0.98, blue: 0.85))
                .frame(width: size * 0.35, height: size * 0.35)
            Circle()
                .fill(Color(red: 0.95, green: 0.85, blue: 0.25))
                .frame(width: size * 0.18, height: size * 0.18)
        }
        .frame(width: size, height: size)
    }
}

struct SimpleLeaf: View {
    var size: CGFloat = 15
    
    var body: some View {
        Ellipse()
            .fill(Color(red: 0.38, green: 0.58, blue: 0.38))
            .frame(width: size * 0.6, height: size * 1.2)
    }
}

struct FlowerView: View {
    let type: FlowerType
    var size: CGFloat = 60
    
    var body: some View {
        switch type {
        case .yellowTulip:
            TulipView(size: size)
        case .purpleHyacinth:
            HyacinthView(size: size)
        case .tigerLily:
            TigerLilyView(size: size)
        case .lotusFlower:
            LotusView(size: size)
        case .chamomile:
            ChamomileView(size: size)
        }
    }
}
