import SwiftUI

struct WaveVisualizerView: View {
    let selectedBand: SpectrumBand?
    let animate: Bool
    let onTap: () -> Void
    
    @State private var waveOffset = 0.0
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with band info
            headerSection
            
            // Wave display area
            waveDisplaySection
            
            // Bottom info grid
            infoSection
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.9))
                .stroke(bandColor.opacity(0.5), lineWidth: 1)
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(bandColor)
                .frame(width: 10, height: 10)
                .opacity(animate ? 1.0 : 0.3)
            
            // Band name
            Text(selectedBand?.name ?? "No Signal")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(bandColor)
            
            Spacer()
        }
    }
    
    // MARK: - Wave Display Section
    private var waveDisplaySection: some View {
        VStack(spacing: 8) {
            // Frequency display
            HStack {
                Text("Frequency:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(frequencyText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.cyan)
                    .fontDesign(.monospaced)
                
                Spacer()
                
                Text("Amplitude: \(amplitudeText)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                    .fontDesign(.monospaced)
            }
            
            // Wave visualization
            ZStack {
                // Background grid
                gridBackground
                
                Canvas { context, size in
                    drawWave(context: context, size: size)
                }
                .frame(height: 100)
            }
            .background(Color.black.opacity(0.5))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Info Section
    private var infoSection: some View {
        HStack(spacing: 20) {
            // Wavelength
            VStack(alignment: .leading, spacing: 4) {
                Text("Wavelength")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                Text(selectedBand?.wavelength ?? "---")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
            }
            
            Spacer()
            
            // Energy Level
            VStack(alignment: .center, spacing: 4) {
                Text("Energy")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                Text("\(selectedBand?.energyLevel ?? 0)/5")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(bandColor)
                    .fontDesign(.monospaced)
            }
            
            Spacer()
            
            // Frequency range
            VStack(alignment: .trailing, spacing: 4) {
                Text("Range")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                Text(selectedBand?.frequency ?? "---")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Grid Background
    private var gridBackground: some View {
        ZStack {
            // Horizontal lines
            VStack(spacing: 0) {
                ForEach(0..<6) { i in
                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 0.5)
                    if i < 5 { Spacer() }
                }
            }
            
            // Vertical lines
            HStack(spacing: 0) {
                ForEach(0..<10) { i in
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 0.5)
                    if i < 9 { Spacer() }
                }
            }
        }
    }
    
    // MARK: - Wave Drawing
    private func drawWave(context: GraphicsContext, size: CGSize) {
        let path = Path { path in
            let numberOfPoints = 120
            let stepX = size.width / Double(numberOfPoints - 1)
            
            for i in 0..<numberOfPoints {
                let x = Double(i) * stepX
                let waveFrequency = selectedBand?.waveFrequency ?? 1.0
                let phase = Double(i) * waveFrequency * 0.08 + waveOffset
                let amplitude = animate ? 35.0 : 15.0
                let centerY = size.height / 2
                let y = centerY + amplitude * sin(phase)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        // Draw glow effect
        context.stroke(path, with: .color(bandColor.opacity(0.4)), lineWidth: 6)
        context.stroke(path, with: .color(bandColor.opacity(0.7)), lineWidth: 3)
        context.stroke(path, with: .color(bandColor), lineWidth: 1.5)
    }
    
    // MARK: - Animation
    private func startAnimation() {
        // Reset animation
        waveOffset = 0
        
        // Wave movement
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            waveOffset = .pi * 4
        }
    }
    
    // MARK: - Computed Properties
    private var bandColor: Color {
        selectedBand?.color ?? Color.gray
    }
    
    private var frequencyText: String {
        guard let band = selectedBand else { return "---" }
        switch band.name {
        case "Radio Waves": return "3Hz-300GHz"
        case "Microwaves": return "300MHz-300GHz"
        case "Infrared": return "300GHz-430THz"
        case "Visible Light": return "430-750THz"
        case "Ultraviolet": return "750THz-30PHz"
        case "X-rays": return "30PHz-30EHz"
        case "Gamma Rays": return ">30EHz"
        default: return "---"
        }
    }
    
    private var amplitudeText: String {
        animate ? "±2.4V" : "±0.8V"
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
