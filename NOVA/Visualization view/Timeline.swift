import SwiftUI

struct DiscoveryTimeline: View {
    let selectedBand: SpectrumBand?
    @State private var timelineAnimation: Double = 0
    
    private let discoveries = [
        ("Radio", "1886", "Heinrich Hertz"),
        ("Infrared", "1800", "William Herschel"),
        ("UV", "1801", "Johann Ritter"),
        ("X-ray", "1895", "Wilhelm Röntgen"),
        ("Gamma", "1900", "Paul Villard")
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.8))
                .frame(height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            selectedBand?.color.opacity(0.3) ?? Color.white.opacity(0.1),
                            lineWidth: 1
                        )
                )
            
            VStack(spacing: 12) {
                Text("Discovery Timeline")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                if let band = selectedBand {
                    let discovery = discoveries.first { $0.0.lowercased() == band.name.prefix(5).lowercased() }
                    
                    if let discovery = discovery {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundStyle(band.color)
                                
                                Text("Discovered in \(discovery.1)")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                            }
                            
                            HStack {
                                Image(systemName: "person.circle")
                                    .foregroundStyle(band.color)
                                
                                Text("by \(discovery.2)")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                            }
                            
                            Text("That's \(2024 - Int(discovery.1)!) years ago!")
                                .font(.caption)
                                .foregroundStyle(band.color)
                        }
                        .scaleEffect(timelineAnimation)
                    } else {
                        Text("Visible light has been known since ancient times")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    Text("Select a band to see discovery history")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .padding(16)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                timelineAnimation = 1.0
            }
        }
        .onChange(of: selectedBand) { _, _ in
            timelineAnimation = 0.8
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                timelineAnimation = 1.0
            }
        }
    }
}
