import SwiftUI

struct DetailView: View {
    let band: SpectrumBand
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(band.name)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(band.color)
                
                Spacer()
                
                Text(band.wavelength)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.ultraThinMaterial))
                    .foregroundStyle(.white)
            }
            
            Text(band.description)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .lineSpacing(3)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 6) {
                ForEach(band.examples, id: \.self) { example in
                    Text(example)
                        .font(.caption)
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 6).fill(band.color.opacity(0.2)))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: band.color.opacity(0.2), radius: 10)
        )
    }
}
