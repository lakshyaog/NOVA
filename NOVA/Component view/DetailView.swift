import SwiftUI

struct DetailView: View {
    let band: SpectrumBand
    
    @State private var selectedExample: ExampleDetail? = nil
    @State private var showMiniGame = false
    @State private var tappedExample: String? = nil
    
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
            
            // Interactive examples hint
            HStack(spacing: 4) {
                Image(systemName: "hand.tap.fill")
                    .font(.caption2)
                Text("Tap an example to learn more")
                    .font(.caption2)
            }
            .foregroundColor(band.color.opacity(0.8))
            .padding(.top, 4)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(band.examples, id: \.self) { example in
                    InteractiveExampleButton(
                        example: example,
                        bandColor: band.color,
                        isTapped: tappedExample == example,
                        onTap: {
                            handleExampleTap(example)
                        }
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
        .sheet(isPresented: $showMiniGame) {
            if let example = selectedExample {
                ExampleMiniGameView(
                    example: example,
                    bandColor: band.color,
                    isPresented: $showMiniGame
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial)
            }
        }
    }
    
    private func handleExampleTap(_ example: String) {
        HapticFeedback.medium()
        
        // Animate button tap
        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
            tappedExample = example
        }
        
        // Reset and show mini-game
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                tappedExample = nil
            }
            
            if let detail = ExampleDetail.detail(for: example, bandName: band.name) {
                selectedExample = detail
                showMiniGame = true
            }
        }
    }
}

// MARK: - Interactive Example Button
struct InteractiveExampleButton: View {
    let example: String
    let bandColor: Color
    let isTapped: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                // Pulsing indicator
                Circle()
                    .fill(bandColor)
                    .frame(width: 6, height: 6)
                    .opacity(0.8)
                
                Text(example)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Spacer(minLength: 0)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(bandColor.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .scaleEffect(isTapped ? 0.95 : 1.0)
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
