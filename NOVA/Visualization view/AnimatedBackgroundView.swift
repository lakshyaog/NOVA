import SwiftUI

struct AnimatedBackgroundView: View {
    @State private var moveUp = false
    @State private var fadeIn = false
    @State private var gradientShift = false
    
    var body: some View {
        ZStack {
            // Enhanced base gradient with radial overlay
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.05),
                        Color.cyan.opacity(0.1),
                        Color.blue.opacity(0.15),
                        Color.clear
                    ],
                    center: gradientShift ? .topLeading : .bottomTrailing,
                    startRadius: 50,
                    endRadius: 400
                )
            )
            
            // Enhanced animated dots with gradient fills
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(fadeIn ? 0.3 : 0.1),
                                Color.cyan.opacity(fadeIn ? 0.2 : 0.05),
                                Color.blue.opacity(fadeIn ? 0.15 : 0.03)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 2
                        )
                    )
                    .frame(width: 4, height: 4)
                    .overlay( 
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.cyan.opacity(fadeIn ? 0.6 : 0.2),
                                        Color.blue.opacity(fadeIn ? 0.4 : 0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
                    .offset(y: moveUp ? -20 : 20)
                    .offset(x: CGFloat(i * 50 - 100))
                    .opacity(fadeIn ? 0.8 : 0.2)
                    .shadow(color: .cyan.opacity(fadeIn ? 0.3 : 0.1), radius: 4)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                moveUp.toggle()
            }
            withAnimation(.easeIn(duration: 2).repeatForever(autoreverses: true)) {
                fadeIn.toggle()
            }
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                gradientShift.toggle()
            }
        }
    }
}
