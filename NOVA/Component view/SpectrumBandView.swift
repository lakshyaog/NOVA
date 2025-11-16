import SwiftUI

struct SpectrumBandView: View {
    let band: SpectrumBand
    let isSelected: Bool
    let glowIntensity: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(band.color.opacity(isSelected ? 0.8 : 0.6))
                .frame(width: isSelected ? 60 : 50, height: isSelected ? 60 : 50)
                .overlay(
                    Image(systemName: band.icon)
                        .font(.system(size: isSelected ? 22 : 18))
                        .foregroundColor(.white)
                )
            
            Text(band.name)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 70)
        }
        .frame(minWidth: 80, minHeight: 100)
        .contentShape(Rectangle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
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
