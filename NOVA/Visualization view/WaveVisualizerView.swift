import SwiftUI

struct WaveVisualizerView: View {
    let selectedBand: SpectrumBand?
    let animate: Bool
    let onTap: () -> Void
    
    @State private var waveOffset = 0.0
    @State private var amplitude: Double = 1.0
    @State private var particles: [WaveParticle] = []
    @State private var touchLocation: CGPoint?
    @State private var ripples: [Ripple] = []
    @State private var selectedWaveType: WaveType = .sine
    
    enum WaveType: String, CaseIterable {
        case sine = "Sine"
        case layered = "Layered"
        case particle = "Particle"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with wave type selector
            headerSection
            
            // Main interactive wave canvas
            interactiveWaveCanvas
            
            // Wave properties display
            propertiesSection
            
            // Interactive hint
            Text("Tap and drag to interact with the wave")
                .font(.caption2)
                .foregroundColor(bandColor.opacity(0.6))
                .italic()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(bandColor.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            startAnimation()
            generateParticles()
        }
        .onChange(of: animate) { _, newValue in
            if newValue {
                startAnimation()
            }
        }
        .onChange(of: selectedBand) { _, _ in
            generateParticles()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Wave Visualizer")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(selectedBand?.name ?? "Select a band")
                    .font(.caption)
                    .foregroundColor(bandColor)
            }
            
            Spacer()
            
            // Wave type picker
            HStack(spacing: 8) {
                ForEach(WaveType.allCases, id: \.self) { type in
                    Button(action: {
                        HapticFeedback.light()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedWaveType = type
                        }
                    }) {
                        Text(type.rawValue)
                            .font(.caption2.bold())
                            .foregroundColor(selectedWaveType == type ? .white : bandColor.opacity(0.6))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(selectedWaveType == type ? bandColor.opacity(0.3) : Color.clear)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Interactive Wave Canvas
    private var interactiveWaveCanvas: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.5),
                        bandColor.opacity(0.1),
                        Color.black.opacity(0.5)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Wave visualization based on selected type
                switch selectedWaveType {
                case .sine:
                    sineWaveView(size: geometry.size)
                case .layered:
                    layeredWaveView(size: geometry.size)
                case .particle:
                    particleWaveView(size: geometry.size)
                }
                
                // Ripple effects
                ForEach(ripples) { ripple in
                    Circle()
                        .stroke(bandColor.opacity(ripple.opacity), lineWidth: 2)
                        .frame(width: ripple.radius * 2, height: ripple.radius * 2)
                        .position(ripple.position)
                }
                
                // Energy indicator
                energyIndicator(size: geometry.size)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        handleDrag(value, in: geometry.size)
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            amplitude = 1.0
                            touchLocation = nil
                        }
                    }
            )
        }
        .frame(height: 180)
    }
    
    // MARK: - Sine Wave View
    private func sineWaveView(size: CGSize) -> some View {
        Canvas { context, canvasSize in
            // Draw multiple layered waves for depth
            for layer in 0..<3 {
                let layerOpacity = 1.0 - (Double(layer) * 0.3)
                let layerOffset = Double(layer) * 10.0
                
                let path = Path { path in
                    let numberOfPoints = 150
                    let stepX = canvasSize.width / Double(numberOfPoints - 1)
                    
                    for i in 0..<numberOfPoints {
                        let x = Double(i) * stepX
                        let waveFrequency = (selectedBand?.waveFrequency ?? 1.0) + Double(layer) * 0.2
                        let phase = Double(i) * waveFrequency * 0.08 + waveOffset + layerOffset
                        let baseAmplitude = animate ? 30.0 : 15.0
                        let finalAmplitude = baseAmplitude * amplitude
                        let centerY = canvasSize.height / 2
                        let y = centerY + finalAmplitude * sin(phase)
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                
                context.stroke(
                    path,
                    with: .color(bandColor.opacity(layerOpacity)),
                    lineWidth: 3 - CGFloat(layer)
                )
            }
        }
    }
    
    // MARK: - Layered Wave View
    private func layeredWaveView(size: CGSize) -> some View {
        Canvas { context, canvasSize in
            // Draw 5 waves with different frequencies and phases
            for layer in 0..<5 {
                let layerOpacity = 0.8 - (Double(layer) * 0.15)
                let phaseShift = Double(layer) * .pi / 3
                
                let path = Path { path in
                    let numberOfPoints = 120
                    let stepX = canvasSize.width / Double(numberOfPoints - 1)
                    
                    for i in 0..<numberOfPoints {
                        let x = Double(i) * stepX
                        let waveFrequency = (selectedBand?.waveFrequency ?? 1.0) * (1.0 + Double(layer) * 0.3)
                        let phase = Double(i) * waveFrequency * 0.08 + waveOffset + phaseShift
                        let baseAmplitude = 20.0 - Double(layer) * 3.0
                        let finalAmplitude = baseAmplitude * amplitude
                        let centerY = canvasSize.height / 2 + Double(layer) * 5.0
                        let y = centerY + finalAmplitude * sin(phase)
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                
                context.stroke(
                    path,
                    with: .color(bandColor.opacity(layerOpacity)),
                    lineWidth: 2.5
                )
            }
        }
    }
    
    // MARK: - Particle Wave View
    private func particleWaveView(size: CGSize) -> some View {
        Canvas { context, canvasSize in
            for particle in particles {
                let waveFrequency = selectedBand?.waveFrequency ?? 1.0
                let phase = particle.x * waveFrequency * 0.08 + waveOffset
                let baseAmplitude = 35.0
                let finalAmplitude = baseAmplitude * amplitude
                let centerY = canvasSize.height / 2
                let y = centerY + finalAmplitude * sin(phase)
                
                let position = CGPoint(x: particle.x * canvasSize.width, y: y)
                let size = particle.size * amplitude
                
                context.fill(
                    Circle().path(in: CGRect(x: position.x - size/2, y: position.y - size/2, width: size, height: size)),
                    with: .color(bandColor.opacity(particle.opacity))
                )
                
                // Add glow effect
                context.fill(
                    Circle().path(in: CGRect(x: position.x - size, y: position.y - size, width: size * 2, height: size * 2)),
                    with: .color(bandColor.opacity(particle.opacity * 0.2))
                )
            }
        }
    }
    
    // MARK: - Energy Indicator
    private func energyIndicator(size: CGSize) -> some View {
        VStack {
            Spacer()
            HStack(spacing: 2) {
                ForEach(0..<20, id: \.self) { index in
                    let isActive = Double(index) < (amplitude * 20.0 * (animate ? 1.0 : 0.5))
                    RoundedRectangle(cornerRadius: 1)
                        .fill(isActive ? bandColor : Color.white.opacity(0.1))
                        .frame(width: 3, height: isActive ? 12 : 6)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isActive)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.5))
            )
            .padding(.bottom, 8)
        }
    }
    
    // MARK: - Properties Section
    private var propertiesSection: some View {
        HStack(spacing: 20) {
            propertyItem(title: "Wavelength", value: selectedBand?.wavelength ?? "---", icon: "arrow.left.and.right")
            
            Divider()
                .frame(height: 30)
                .background(Color.white.opacity(0.2))
            
            propertyItem(title: "Frequency", value: selectedBand?.frequency ?? "---", icon: "waveform")
            
            Divider()
                .frame(height: 30)
                .background(Color.white.opacity(0.2))
            
            propertyItem(title: "Energy", value: selectedBand?.energyDescription ?? "---", icon: "bolt.fill")
        }
    }
    
    private func propertyItem(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(bandColor)
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.caption.bold())
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Functions
    private func handleDrag(_ value: DragGesture.Value, in size: CGSize) {
        HapticFeedback.selection()
        
        let location = value.location
        touchLocation = location
        
        // Calculate amplitude based on vertical position
        let normalizedY = location.y / size.height
        amplitude = 1.0 + (0.5 - normalizedY) * 2.0
        amplitude = max(0.3, min(2.0, amplitude))
        
        // Create ripple effect
        createRipple(at: location)
    }
    
    private func createRipple(at position: CGPoint) {
        let ripple = Ripple(position: position)
        ripples.append(ripple)
        
        withAnimation(.easeOut(duration: 1.0)) {
            if let index = ripples.firstIndex(where: { $0.id == ripple.id }) {
                ripples[index].radius = 50
                ripples[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ripples.removeAll { $0.id == ripple.id }
        }
    }
    
    private func startAnimation() {
        waveOffset = 0
        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
            waveOffset = .pi * 4
        }
    }
    
    private func generateParticles() {
        particles = (0..<60).map { i in
            WaveParticle(
                x: Double(i) / 60.0,
                size: CGFloat.random(in: 3...6),
                opacity: Double.random(in: 0.4...0.9)
            )
        }
    }
    
    private var bandColor: Color {
        selectedBand?.color ?? Color.gray
    }
}

// MARK: - Supporting Models
struct WaveParticle: Identifiable {
    let id = UUID()
    let x: Double
    let size: CGFloat
    let opacity: Double
}

struct Ripple: Identifiable {
    let id = UUID()
    let position: CGPoint
    var radius: CGFloat = 0
    var opacity: Double = 0.6
}

// MARK: - Preview
#Preview {
    WaveVisualizerView(
        selectedBand: SpectrumBand.sampleBands[3],
        animate: true,
        onTap: {}
    )
    .padding()
    .background(Color.black)
}
