import SwiftUI

struct InfoView: View {
    @State private var animateCards = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced animated background
                AnimatedBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "wave.3.right.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.cyan, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Electromagnetic Spectrum")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        .opacity(animateCards ? 1 : 0)
                        
                        // Simplified Info Cards
                        LazyVStack(spacing: 16) {
                            InfoCardView(
                                icon: "lightbulb.fill",
                                title: "What is EM Spectrum?",
                                description: "The range of all electromagnetic radiation from radio waves to gamma rays.",
                                color: .orange,
                                delay: 0.1
                            )
                            
                            InfoCardView(
                                icon: "eye.fill",
                                title: "Visible Light",
                                description: "Only 0.0035% of the EM spectrum is visible to human eyes!",
                                color: .green,
                                delay: 0.2
                            )
                            
                            InfoCardView(
                                icon: "sparkles",
                                title: "Interactive Learning",
                                description: "Tap spectrum bands to explore and watch visualizations!",
                                color: .cyan,
                                delay: 0.3
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animateCards = true
            }
        }
    }
}
