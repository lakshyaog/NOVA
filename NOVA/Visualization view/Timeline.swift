import SwiftUI

struct DiscoveryTimeline: View {
    let selectedBand: SpectrumBand?
    
    private let discoveries = [
        ("Radio", "1886", "Heinrich Hertz"),
        ("Infrared", "1800", "William Herschel"),
        ("UV", "1801", "Johann Ritter"),
        ("X-ray", "1895", "Wilhelm Röntgen"),
        ("Gamma", "1900", "Paul Villard")
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Discovery Timeline")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let band = selectedBand {
                let discovery = discoveries.first { $0.0.lowercased() == band.name.prefix(5).lowercased() }
                
                if let discovery = discovery {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                            Text("Discovered in \(discovery.1)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(.gray)
                            Text("by \(discovery.2)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    Text("Visible light has been known since ancient times")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            } else {
                Text("Select a band to see discovery history")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(height: 40)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}
