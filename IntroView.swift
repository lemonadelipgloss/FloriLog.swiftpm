import SwiftUI

struct IntroView: View {
    @Binding var showIntro: Bool
    @State private var currentPage = 0
    @State private var flowerScale: CGFloat = 0
    @State private var flowerOpacity: Double = 0
    
    private struct FMN { let x: CGFloat; let y: CGFloat; let rot: Double; let size: CGFloat; let color: ForgetMeNotView.ForgetMeNotColor }

    private let backgroundFlowers: [FMN] = [
        FMN(x: 0.08, y: 0.12, rot: -12, size: 28, color: .blue),
        FMN(x: 0.90, y: 0.15, rot: 7,   size: 30, color: .pink),
        FMN(x: 0.18, y: 0.26, rot: -6,  size: 26, color: .white),
        FMN(x: 0.78, y: 0.28, rot: 11,  size: 24, color: .blue),
        FMN(x: 0.14, y: 0.44, rot: -4,  size: 32, color: .pink),
        FMN(x: 0.88, y: 0.46, rot: 5,   size: 26, color: .blue),
        FMN(x: 0.10, y: 0.62, rot: -9,  size: 24, color: .white),
        FMN(x: 0.86, y: 0.64, rot: 9,   size: 28, color: .pink),
        FMN(x: 0.20, y: 0.78, rot: -7,  size: 30, color: .blue),
        FMN(x: 0.74, y: 0.80, rot: 4,   size: 26, color: .white),
        FMN(x: 0.12, y: 0.88, rot: -5,  size: 24, color: .pink)
    ]
    
    let pages: [IntroPage] = [
        IntroPage(
            flowerType: .lotusFlower,
            title: "Welcome to FloriLog",
            description: "Track your emotional journey through the timeless Victorian language of flowers"
        ),
        IntroPage(
            flowerType: .yellowTulip,
            title: "Choose Your Bloom",
            description: "Each day, select the flower that speaks to your heart. Five flowers, five moods, infinite meaning."
        ),
        IntroPage(
            flowerType: .purpleHyacinth,
            title: "Weekly Bouquets",
            description: "Watch your emotions arrange into beautiful Victorian bouquets. Save them to revisit your journey."
        ),
        IntroPage(
            flowerType: .chamomile,
            title: "Your Garden Awaits",
            description: "Your calendar blooms into a living garden. Each entry a petal in your story."
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.sageGradient.ignoresSafeArea()
            
            GeometryReader { geo in

                ForEach(0..<backgroundFlowers.count, id: \.self) { i in
                    let f = backgroundFlowers[i]
                    ZStack {
                        ForgetMeNotView(size: f.size, color: f.color)
                        if i % 3 == 0 {
                            SimpleLeaf(size: max(14, f.size * 0.5))
                                .rotationEffect(.degrees(42))
                                .offset(x: -f.size * 0.35, y: f.size * 0.28)
                        }
                    }
                    .opacity(0.35)
                    .position(x: f.x * geo.size.width, y: f.y * geo.size.height)
                    .rotationEffect(.degrees(f.rot))
                }
            }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") {
                        HapticManager.selection()
                        withAnimation {
                            showIntro = false
                        }
                    }
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Theme.roseDust)
                    .cornerRadius(20)
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Theme.warmWhite.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .blur(radius: 25)
                    
                    Circle()
                        .fill(Theme.warmWhite.opacity(0.30))
                        .frame(width: 170, height: 170)
                    
                    FlowerView(type: pages[currentPage].flowerType, size: 95)
                        .scaleEffect(flowerScale)
                        .opacity(flowerOpacity)
                }
                .padding(.bottom, 35)
                
                VStack(spacing: 18) {
                    Text(pages[currentPage].title)
                        .font(.custom("Georgia", size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.warmWhite)
                        .multilineTextAlignment(.center)
                    
                    Text(pages[currentPage].description)
                        .font(.custom("Georgia", size: 17))
                        .foregroundColor(Theme.warmWhite.opacity(0.88))
                        .multilineTextAlignment(.center)
                        .lineSpacing(7)
                        .padding(.horizontal, 38)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Theme.warmWhite.opacity(0.14))
                        .padding(.horizontal, 18)
                )
                
                Spacer()
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        if index == currentPage {
                            Capsule()
                                .fill(Theme.warmWhite)
                                .frame(width: 28, height: 9)
                        } else {
                            Circle()
                                .fill(Theme.warmWhite.opacity(0.35))
                                .frame(width: 9, height: 9)
                        }
                    }
                }
                .animation(.spring(response: 0.4), value: currentPage)
                .padding(.bottom, 28)
                
                Button(action: {
                    HapticManager.impact(.medium)
                    if currentPage < pages.count - 1 {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            flowerScale = 0
                            flowerOpacity = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            currentPage += 1
                            animateFlower()
                        }
                    } else {
                        withAnimation {
                            showIntro = false
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Begin Your Garden!")
                        .font(.custom("Georgia", size: 19))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Theme.roseDust)
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 55)
            }
        }
        .onAppear {
            animateFlower()
        }
    }
    
    func animateFlower() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
            flowerScale = 1.0
            flowerOpacity = 1.0
        }
        HapticManager.impact(.light)
    }
}

struct IntroPage {
    let flowerType: FlowerType
    let title: String
    let description: String
}
