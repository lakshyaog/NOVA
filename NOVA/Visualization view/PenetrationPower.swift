import SwiftUI

struct PenetrationPower: View {
    let selectedBand: SpectrumBand?
    
    private let materials = [
        ("Paper", "📄", 1),
        ("Skin", "✋", 2),
        ("Wood", "🪵", 3),
        ("Metal", "🔩", 4),
        ("Lead", "🛡️", 5)
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Penetration Power")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let band = selectedBand {
                HStack(spacing: 0) {
                    ForEach(Array(materials.enumerated()), id: \.offset) { index, material in
                        let canPenetrate = band.energyLevel >= material.2
                        
                        VStack(spacing: 4) {
                            Text(material.1)
                                .font(.title3)
                                .opacity(canPenetrate ? 1.0 : 0.3)
                            
                            Text(material.0)
                                .font(.system(size: 9))
                                .foregroundColor(canPenetrate ? .white : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Text("Can penetrate \(getPenetrationDescription(band.energyLevel))")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Select a band to see penetration power")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(height: 60)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
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
