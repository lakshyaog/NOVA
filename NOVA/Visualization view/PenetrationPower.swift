import SwiftUI

struct PenetrationPower: View {
    let selectedBand: SpectrumBand?
    @State private var penetrationAnimation: Double = 0
    @State private var rayAnimation: Double = 0
    
    private let materials = [
        ("Paper", "📄", 1),
        ("Skin", "✋", 2),
        ("Wood", "🪵", 3),
        ("Metal", "🔩", 4),
        ("Lead", "🛡️", 5)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header section with fixed height
            VStack(spacing: 8) {
                Text("Penetration Power")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                
                // Penetration visualization
                if let band = selectedBand {
                    HStack(spacing: 8) {
                        // Radiation source
                        Circle()
                            .fill(band.color)
                            .frame(width: 12, height: 12)
                            .shadow(color: band.color, radius: 4)
                        
                        // Penetration ray
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        band.color,
                                        band.color.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: CGFloat(band.energyLevel * 25), height: 3)
                            .scaleEffect(x: rayAnimation, anchor: .leading)
                        
                        Spacer()
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 16)
                }
            }
            .frame(height: 60)
            .padding(.top, 12)
            
            // Materials section with consistent spacing
            VStack(spacing: 8) {
                if let band = selectedBand {
                    // Materials grid
                    HStack(spacing: 0) {
                        ForEach(Array(materials.enumerated()), id: \.offset) { index, material in
                            let canPenetrate = band.energyLevel >= material.2
                            
                            VStack(spacing: 4) {
                                Text(material.1)
                                    .font(.title3)
                                    .opacity(canPenetrate ? 1.0 : 0.3)
                                    .overlay(
                                        // Strike-through for non-penetrable
                                        Rectangle()
                                            .fill(.red)
                                            .frame(height: 2)
                                            .opacity(canPenetrate ? 0 : 0.8)
                                    )
                                
                                Text(material.0)
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundStyle(canPenetrate ? band.color : .gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Description text
                    Text("\(band.name) can penetrate \(getPenetrationDescription(band.energyLevel))")
                        .font(.caption)
                        .foregroundStyle(band.color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 16)
                        .frame(height: 32)
                } else {
                    Text("Select a band to see penetration power")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(height: 72)
                }
            }
            .frame(minHeight: 72)
            .padding(.bottom, 12)
        }
        .frame(height: 144) // Fixed total height
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            selectedBand?.color.opacity(0.3) ?? Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .onAppear {
            startPenetrationAnimation()
        }
        .onChange(of: selectedBand) { _, _ in
            rayAnimation = 0
            withAnimation(.easeOut(duration: 1)) {
                rayAnimation = 1.0
            }
        }
    }
    
    private func startPenetrationAnimation() {
        withAnimation(.easeOut(duration: 1)) {
            rayAnimation = 1.0
        }
        
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            penetrationAnimation = 1.0
        }
    }
    
    private func getPenetrationDescription(_ level: Int) -> String {
        switch level {
        case 1: return "soft materials only"
        case 2: return "paper and thin materials"
        case 3: return "skin and wood"
        case 4: return "most metals"
        case 5: return "almost everything"
        default: return "minimal penetration"
        }
    }
}
