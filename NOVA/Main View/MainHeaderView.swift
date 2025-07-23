import SwiftUI

struct MainHeaderView: View {
    @Binding var showingInfo: Bool
    let onInfoTap: () -> Void
    
    @State private var titleShimmer = false
    @State private var subtitleGlow = false
    @State private var backgroundPulse = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Enhanced title section
            VStack(alignment: .leading, spacing: 6) {
                // Main title with advanced gradient and effects
                Text("EM Spectrum")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                .white,
                                .cyan.opacity(0.9),
                                .blue.opacity(0.8),
                                .purple.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        // Shimmer effect overlay
                        Text("EM Spectrum")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(titleShimmer ? 0.8 : 0.0),
                                        Color.clear
                                    ],
                                    startPoint: UnitPoint(x: titleShimmer ? -0.3 : -1.0, y: 0.5),
                                    endPoint: UnitPoint(x: titleShimmer ? 1.3 : 0.0, y: 0.5)
                                )
                            )
                            .mask(
                                Text("EM Spectrum")
                                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                            )
                    )
                    .shadow(color: .cyan.opacity(0.6), radius: 8, x: 0, y: 0)
                    .shadow(color: .blue.opacity(0.4), radius: 4, x: 2, y: 2)
                
                // Enhanced subtitle
                HStack(spacing: 6) {
                    // Decorative wave indicator
                    Image(systemName: "wave.3.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.cyan.opacity(subtitleGlow ? 0.9 : 0.6))
                        .scaleEffect(subtitleGlow ? 1.1 : 1.0)
                    
                    Text("Explore the invisible")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.8),
                                    .cyan.opacity(0.6)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .white.opacity(0.3), radius: 1)
                }
                .opacity(subtitleGlow ? 1.0 : 0.8)
            }
            
            Spacer()
            
            // Enhanced info button
            Button {
                HapticFeedback.light()
                onInfoTap()
            } label: {
                EnhancedInfoButtonView(isActive: showingInfo)
            }
        }
        .padding(.top, 50) // Added top padding to pull it down
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            // Subtle background enhancement
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.3),
                            Color.gray.opacity(0.1),
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(backgroundPulse ? 0.8 : 0.6)
        )
        .overlay(
            // Border enhancement
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.cyan.opacity(0.3),
                            Color.clear,
                            Color.purple.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Title shimmer effect
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            titleShimmer = true
        }
        
        // Subtitle glow effect
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            subtitleGlow = true
        }
        
        // Background pulse
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            backgroundPulse = true
        }
    }
}

struct EnhancedInfoButtonView: View {
    let isActive: Bool
    @State private var buttonPulse = false
    
    var body: some View {
        ZStack {
            // Background circle with enhanced gradient
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(isActive ? 0.25 : 0.15),
                            Color.cyan.opacity(isActive ? 0.3 : 0.1),
                            Color.blue.opacity(isActive ? 0.2 : 0.05)
                        ],
                        center: .topLeading,
                        startRadius: 5,
                        endRadius: 25
                    )
                )
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.cyan.opacity(isActive ? 0.8 : 0.4),
                                    Color.blue.opacity(isActive ? 0.6 : 0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isActive ? 2 : 1
                        )
                )
                .scaleEffect(buttonPulse ? 1.05 : 1.0)
                .shadow(color: .cyan.opacity(isActive ? 0.5 : 0.2), radius: 8)
            
            // Enhanced info icon
            Image(systemName: isActive ? "info.circle.fill" : "info.circle")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.cyan.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .white.opacity(0.5), radius: 2)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                buttonPulse = true
            }
        }
    }
}
