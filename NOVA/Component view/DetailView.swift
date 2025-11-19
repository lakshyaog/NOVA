import SwiftUI

struct DetailView: View {
    let band: SpectrumBand
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(band.name)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(band.wavelength)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(band.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(2)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(band.examples, id: \.self) { example in
                    Text(example)
                        .font(.caption)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(6)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}
