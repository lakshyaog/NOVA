import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image(systemName: "wave.3.right.circle")
                            .font(.system(size: 54, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("About NOVA")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 16) {
                            InfoCardView(
                                icon: "lightbulb.fill",
                                title: "What is EM Spectrum?",
                                description: "The range of all electromagnetic radiation from radio waves to gamma rays.",
                                color: .orange,
                                delay: 0
                            )
                            
                            InfoCardView(
                                icon: "eye.fill",
                                title: "Visible Light",
                                description: "Only 0.0035% of the EM spectrum is visible to human eyes!",
                                color: .green,
                                delay: 0
                            )
                            
                            InfoCardView(
                                icon: "sparkles",
                                title: "Interactive Learning",
                                description: "Tap spectrum bands to explore and watch visualizations!",
                                color: .cyan,
                                delay: 0
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
