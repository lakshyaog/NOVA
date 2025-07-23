import SwiftUI

struct SpectrumBandView: View {
    let band: SpectrumBand
    let isSelected: Bool
    let glowIntensity: Double
    
    @State private var pulse = false
    @State private var shimmer = false
    @State private var glossEffect = false
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // Base circle with enhanced glossy gradient
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                band.color.brightened(by: 0.3).opacity(0.9),
                                band.color.saturated(by: 1.4).opacity(0.8),
                                band.color.opacity(0.6),
                                band.color.darkened(by: 0.2).opacity(0.4)
                            ],
                            center: UnitPoint(x: 0.3, y: 0.3),
                            startRadius: 5,
                            endRadius: 40
                        )
                    )
                    .overlay(
                        // Glossy highlight overlay
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(glossEffect ? 0.4 : 0.2),
                                        Color.white.opacity(0.1),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                    )
                    .overlay(
                        // Shimmer effect
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(shimmer ? 0.6 : 0.0),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .frame(width: isSelected ? 70 : 60, height: isSelected ? 70 : 60)
                    .shadow(
                        color: band.color.saturated(by: 1.5).opacity(glowIntensity * 0.7),
                        radius: isSelected ? 20 : 10
                    )
                    .shadow(
                        color: band.color.brightened(by: 0.4).opacity(glowIntensity * 0.4),
                        radius: isSelected ? 8 : 4
                    )
                    .scaleEffect(pulse ? 1.05 : 1.0)
                
                // Icon with enhanced styling
                Image(systemName: band.icon)
                    .font(.system(size: isSelected ? 24 : 20, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.white.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                    .shadow(color: band.color.brightened(by: 0.5), radius: 4)
            }
            .padding(.horizontal, 15) // Reduced padding for better spacing
            .padding(.vertical, 12)   // Reduced padding for better spacing
            
            Text(band.name)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(isSelected ? 1.0 : 0.9),
                            Color.white.opacity(isSelected ? 0.9 : 0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: band.color.opacity(0.5), radius: 1)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 75)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .frame(minWidth: 90, minHeight: 120) // Reduced frame size for better spacing
        .contentShape(Rectangle()) // Makes entire area tappable
        .animation(.easeInOut(duration: 0.2), value: isSelected) // Faster animation
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Delayed animations to prevent interference with touch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                glossEffect = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                shimmer = true
            }
        }
    }
}

// MARK: - Color Extensions for Glossy Effects
extension Color {
    func saturated(by amount: Double) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return Color(hue: Double(hue),
                    saturation: min(1.0, Double(saturation) * amount),
                    brightness: Double(brightness))
    }
    
    func brightened(by amount: Double) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return Color(hue: Double(hue),
                    saturation: Double(saturation),
                    brightness: min(1.0, Double(brightness) + amount))
    }
    
    func darkened(by amount: Double) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return Color(hue: Double(hue),
                    saturation: Double(saturation),
                    brightness: max(0.0, Double(brightness) - amount))
    }
}
