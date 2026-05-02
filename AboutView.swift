import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.sageGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        VStack(spacing: 12) {
                            ForgetMeNotView(size: 65, color: .blue)
                            
                            Text("About FloriLog")
                                .font(.custom("Georgia", size: 28))
                                .bold()
                                .foregroundColor(Theme.warmWhite)
                            
                            Text("The Language of Flowers")
                                .font(.custom("Georgia", size: 16))
                                .italic()
                                .foregroundColor(Theme.warmWhite.opacity(0.75))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 12)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("What is Floriography?")
                                .font(.custom("Georgia", size: 22))
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.warmWhite)
                            
                            Text("Floriography, or the language of flowers, was a Victorian-era means of communication where flowers and floral arrangements were used to send coded messages. Each flower held symbolic meaning, allowing people to express emotions that couldn't be spoken aloud in the strict social conventions of the time.")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Theme.warmWhite.opacity(0.85))
                                .lineSpacing(6)
                        }
                        .padding(.horizontal)
                        
                        Rectangle()
                            .fill(Theme.warmWhite.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Your Mood Garden")
                                .font(.custom("Georgia", size: 22))
                                .fontWeight(.semibold)
                                .foregroundColor(Theme.warmWhite)
                                .padding(.horizontal)
                            
                            FlowerMeaningCard(
                                type: .yellowTulip,
                                mood: "Happy",
                                meaning: "Sunshine in your smile"
                            )
                            
                            FlowerMeaningCard(
                                type: .purpleHyacinth,
                                mood: "Sad",
                                meaning: "Sorrow"
                            )
                            
                            FlowerMeaningCard(
                                type: .tigerLily,
                                mood: "Angry",
                                meaning: "Hatred, disdain, anger"
                            )
                            
                            FlowerMeaningCard(
                                type: .lotusFlower,
                                mood: "Calm",
                                meaning: "Purity, enlightenment, self-regeneration and rebirth"
                            )
                            
                            FlowerMeaningCard(
                                type: .chamomile,
                                mood: "Tired",
                                meaning: "Energy in adversity"
                            )
                        }
                        
                        Rectangle()
                            .fill(Theme.warmWhite.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 12) {
                                ForgetMeNotView(size: 40, color: .blue)
                                Text("Forget-Me-Not")
                                    .font(.custom("Georgia", size: 22))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Theme.warmWhite)
                            }
                            .padding(.horizontal)
                            
                            Text("The forget-me-not symbolizes remembrance and true love. In the language of flowers, it speaks of enduring memory and faithful affection. These delicate blue blooms remind us to cherish our moments and emotions, for they become the garden of our memories.")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(Theme.warmWhite.opacity(0.85))
                                .lineSpacing(6)
                                .padding(.horizontal)
                        }
                        
                        Rectangle()
                            .fill(Theme.warmWhite.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal)
                        
                        VStack(spacing: 10) {
                            Text("Track your emotions through the timeless language of flowers")
                                .font(.custom("Georgia", size: 14))
                                .italic()
                                .foregroundColor(Theme.warmWhite.opacity(0.7))
                                .multilineTextAlignment(.center)
                            
                            Text("✿ FloriLog ✿")
                                .font(.custom("Georgia", size: 14))
                                .bold()
                                .foregroundColor(Theme.warmWhite.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About FloriLog")
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
                    .padding(.vertical, 10)
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct FlowerMeaningCard: View {
    let type: FlowerType
    let mood: String
    let meaning: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            FlowerView(type: type, size: 55)
                .frame(width: 75, height: 73)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(type.petalColor.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 7) {
                Text(type.rawValue)
                    .font(.custom("Georgia", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.warmWhite)
                
                Text(mood)
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(type.petalColor)
                    .bold()
                
                Text(meaning)
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(Theme.warmWhite.opacity(0.75))
                    .italic()
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.warmWhite.opacity(0.12))
        )
        .padding(.horizontal)
    }
}
