import SwiftUI

struct WelcomeView: View {
    @State private var isAnimating = false
    @State private var glowOpacity = 0.3
    
    var body: some View {
        VStack(spacing: 24) {
            // Classic ornamental border
            VStack(spacing: 20) {
                // Decorative top border
                HStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 1)
                    
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 1)
                }
                .frame(maxWidth: 200)
                
                // Classic lightbulb with elegant styling
                ZStack {
                    // Subtle glow effect
                    Circle()
                        .fill(RadialGradient(
                            colors: [
                                Color.white.opacity(glowOpacity),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 40
                        ))
                        .frame(width: 80, height: 80)
                    
                    // Main icon with classic styling
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 36, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.white.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .white.opacity(0.3), radius: 2, x: 0, y: 1)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                }
                
                // Classic typography
                VStack(spacing: 8) {
                    Text("Welcome")
                        .font(.system(size: 24, weight: .light, design: .serif))
                        .foregroundColor(.white.opacity(0.95))
                        .tracking(2)
                    
                    Text("Select a spectrum band to begin")
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .tracking(0.5)
                        .lineSpacing(2)
                }
                
                // Decorative bottom border
                HStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 1)
                    
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 1)
                }
                .frame(maxWidth: 200)
            }
            .padding(32)
            .background(
                // Classic card background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                    )
            )
        }
        .onAppear {
            // Gentle breathing animation
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            // Subtle glow pulsing
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                glowOpacity = 0.6
            }
        }
    }
}
