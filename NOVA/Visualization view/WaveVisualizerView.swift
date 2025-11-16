import SwiftUI

struct WaveVisualizerView: View {
    let selectedBand: SpectrumBand?
    let animate: Bool
    let onTap: () -> Void
    
    @State private var waveOffset = 0.0
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(selectedBand?.name ?? "No Signal")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Circle()
                    .fill(bandColor)
                    .frame(width: 8, height: 8)
                    .opacity(animate ? 1.0 : 0.3)
            }
            
            Canvas { context, size in
                drawWave(context: context, size: size)
            }
            .frame(height: 80)
            .background(Color.black.opacity(0.3))
            .cornerRadius(8)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wavelength")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(selectedBand?.wavelength ?? "---")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Frequency")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(selectedBand?.frequency ?? "---")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
        .onTapGesture {
            onTap()
        }
        .onAppear {
            startAnimation()
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                startAnimation()
            }
        }
    }
    
    private func drawWave(context: GraphicsContext, size: CGSize) {
        let path = Path { path in
            let numberOfPoints = 100
            let stepX = size.width / Double(numberOfPoints - 1)
            
            for i in 0..<numberOfPoints {
                let x = Double(i) * stepX
                let waveFrequency = selectedBand?.waveFrequency ?? 1.0
                let phase = Double(i) * waveFrequency * 0.08 + waveOffset
                let amplitude = animate ? 25.0 : 10.0
                let centerY = size.height / 2
                let y = centerY + amplitude * sin(phase)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        context.stroke(path, with: .color(bandColor), lineWidth: 2)
    }
    
    private func startAnimation() {
        waveOffset = 0
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            waveOffset = .pi * 4
        }
    }
    
    private var bandColor: Color {
        selectedBand?.color ?? Color.gray
    }
}

// MARK: - SpectrumBand Extension
extension SpectrumBand {
    var WaveFrequency: Double {
        switch name {
        case "Radio Waves": return 0.4
        case "Microwaves": return 0.6
        case "Infrared": return 0.8
        case "Visible Light": return 1.2
        case "Ultraviolet": return 1.6
        case "X-rays": return 2.0
        case "Gamma Rays": return 2.5
        default: return 1.0
        }
    }
}
