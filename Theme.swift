import SwiftUI

struct Theme {

    static let sageDeep = Color(red: 0.47, green: 0.58, blue: 0.47)
    static let sageMid = Color(red: 0.60, green: 0.72, blue: 0.58)
    static let sageLight = Color(red: 0.78, green: 0.87, blue: 0.75)
    static let sagePale = Color(red: 0.88, green: 0.93, blue: 0.86)
    static let cream = Color(red: 0.99, green: 0.97, blue: 0.93)
    static let warmWhite = Color(red: 0.99, green: 0.98, blue: 0.96)
    
    static let blush = Color(red: 0.98, green: 0.88, blue: 0.88)
    static let petalPink = Color(red: 0.94, green: 0.72, blue: 0.75)
    static let roseDust = Color(red: 0.85, green: 0.55, blue: 0.60)
    static let lavender = Color(red: 0.82, green: 0.76, blue: 0.94)
    static let goldenYellow = Color(red: 0.98, green: 0.85, blue: 0.40)
    static let softOrange = Color(red: 0.98, green: 0.75, blue: 0.50)
    
    static let deepBranch = Color(red: 0.22, green: 0.28, blue: 0.22)
    static let secondaryText = Color(red: 0.40, green: 0.50, blue: 0.40)
    
    static let background = sageMid
    static let cardBackground = warmWhite
    static let primaryText = deepBranch
    static let accent = roseDust
    
    static let sageGradient = LinearGradient(
        colors: [
            Color(red: 0.52, green: 0.65, blue: 0.50),
            Color(red: 0.58, green: 0.72, blue: 0.55),
            Color(red: 0.64, green: 0.78, blue: 0.60)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [warmWhite, cream],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Haptics
@MainActor
struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Flower Button Shape
struct FlowerShape: Shape {
    var petals: Int = 5
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let petalLength = min(rect.width, rect.height) / 2
        let petalWidth = petalLength * 0.5
        var path = Path()
        
        for i in 0..<petals {
            let angle = (Double(i) / Double(petals)) * 2 * .pi - .pi / 2
            let petalCenter = CGPoint(
                x: center.x + cos(angle) * petalLength * 0.5,
                y: center.y + sin(angle) * petalLength * 0.5
            )
            path.addEllipse(in: CGRect(
                x: petalCenter.x - petalWidth / 2,
                y: petalCenter.y - petalLength * 0.35,
                width: petalWidth,
                height: petalLength * 0.7
            ).applying(CGAffineTransform(
                rotationAngle: angle + .pi / 2
            ).translatedBy(
                x: -petalCenter.x,
                y: -petalCenter.y
            ).translatedBy(
                x: petalCenter.x,
                y: petalCenter.y
            )))
        }
        
        path.addEllipse(in: CGRect(
            x: center.x - petalLength * 0.2,
            y: center.y - petalLength * 0.2,
            width: petalLength * 0.4,
            height: petalLength * 0.4
        ))
        
        return path
    }
}

// MARK: - Flower Button Style
struct FlowerButtonStyle: ButtonStyle {
    var color: Color = Theme.petalPink
    var size: CGFloat = 50
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .fill(color.opacity(configuration.isPressed ? 0.6 : 0.25))
                .frame(width: size, height: size)
            
            ForEach(0..<5) { i in
                Ellipse()
                    .fill(color.opacity(configuration.isPressed ? 0.4 : 0.2))
                    .frame(width: size * 0.35, height: size * 0.5)
                    .offset(y: -size * 0.25)
                    .rotationEffect(.degrees(Double(i) * 72))
            }
            
            Circle()
                .fill(color.opacity(configuration.isPressed ? 0.9 : 0.7))
                .frame(width: size * 0.45, height: size * 0.45)
            
            configuration.label
                .foregroundColor(Theme.deepBranch)
                .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Victorian Vase Shape
struct VictorianVaseShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: w * 0.15, y: h * 0.08))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.85, y: h * 0.08),
            control: CGPoint(x: w * 0.5, y: h * 0.0)
        )
        
        path.addCurve(
            to: CGPoint(x: w * 0.75, y: h * 0.35),
            control1: CGPoint(x: w * 0.92, y: h * 0.12),
            control2: CGPoint(x: w * 0.88, y: h * 0.25)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.82, y: h * 0.65),
            control1: CGPoint(x: w * 0.62, y: h * 0.45),
            control2: CGPoint(x: w * 0.78, y: h * 0.52)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.78, y: h * 0.92),
            control1: CGPoint(x: w * 0.86, y: h * 0.78),
            control2: CGPoint(x: w * 0.84, y: h * 0.88)
        )
        
        path.addQuadCurve(
            to: CGPoint(x: w * 0.22, y: h * 0.92),
            control: CGPoint(x: w * 0.5, y: h * 1.0)
        )
        
        path.addCurve(
            to: CGPoint(x: w * 0.18, y: h * 0.65),
            control1: CGPoint(x: w * 0.16, y: h * 0.88),
            control2: CGPoint(x: w * 0.14, y: h * 0.78)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.25, y: h * 0.35),
            control1: CGPoint(x: w * 0.22, y: h * 0.52),
            control2: CGPoint(x: w * 0.38, y: h * 0.45)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.15, y: h * 0.08),
            control1: CGPoint(x: w * 0.12, y: h * 0.25),
            control2: CGPoint(x: w * 0.08, y: h * 0.12)
        )
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Victorian Vase View
struct VictorianVase: View {
    var body: some View {
        ZStack {
            VictorianVaseShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.90, green: 0.85, blue: 0.78),
                            Color(red: 0.80, green: 0.72, blue: 0.62),
                            Color(red: 0.70, green: 0.60, blue: 0.50)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VictorianVaseShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.0),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack {
                Rectangle()
                    .fill(Color(red: 0.65, green: 0.52, blue: 0.38).opacity(0.6))
                    .frame(height: 2)
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                Spacer()
                Rectangle()
                    .fill(Color(red: 0.65, green: 0.52, blue: 0.38).opacity(0.6))
                    .frame(height: 2)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 22)
            }
            
            VStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("✦")
                        .font(.system(size: 8))
                        .foregroundColor(Color(red: 0.55, green: 0.42, blue: 0.30).opacity(0.7))
                    Text("❋")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.55, green: 0.42, blue: 0.30).opacity(0.7))
                    Text("✦")
                        .font(.system(size: 8))
                        .foregroundColor(Color(red: 0.55, green: 0.42, blue: 0.30).opacity(0.7))
                }
                .padding(.bottom, 55)
            }
        }
    }
}

