import SwiftUI
import ARKit
import RealityKit
import Combine

struct ARSpectrumView: View {
    let selectedBand: SpectrumBand?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var arViewModel = ARViewModel()
    @State private var showLegend = true
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel, selectedBand: selectedBand)
                .ignoresSafeArea()
            
            VStack {
                // Top info bar with legend
                if showLegend && arViewModel.hasPlacedWave {
                    waveLegendView
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                Spacer()
                
                // Bottom controls with refined design
                VStack(spacing: 16) {
                    // Status indicator
                    if arViewModel.hasPlacedWave {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(arViewModel.isAnimating ? Color.green : Color.orange)
                                .frame(width: 6, height: 6)
                            
                            Text(arViewModel.isAnimating ? "Wave Active" : "Paused")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.3))
                        )
                    } else {
                        Text("Tap surface to place wave")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.3))
                            )
                    }
                    
                    // Control buttons
                    HStack(spacing: 12) {
                        // Clear button
                        Button {
                            arViewModel.clearAllWaves()
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 54, height: 54)
                                .background(Color.red.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .opacity(arViewModel.hasPlacedWave ? 1 : 0.3)
                        .disabled(!arViewModel.hasPlacedWave)
                        
                        // Play/Pause button
                        Button {
                            arViewModel.toggleAnimation()
                        } label: {
                            Image(systemName: arViewModel.isAnimating ? "pause.fill" : "play.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 54, height: 54)
                                .background(
                                    selectedBand?.color.opacity(0.7) ?? Color.blue.opacity(0.7)
                                )
                                .clipShape(Circle())
                        }
                        .opacity(arViewModel.hasPlacedWave ? 1 : 0.3)
                        .disabled(!arViewModel.hasPlacedWave)
                        
                        // Legend toggle button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showLegend.toggle()
                            }
                        } label: {
                            Image(systemName: showLegend ? "info.circle.fill" : "info.circle")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 54, height: 54)
                                .background(Color.blue.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .opacity(arViewModel.hasPlacedWave ? 1 : 0.3)
                    }
                }
                .padding(.bottom, 40)
            }
            
            // Surface detection indicator
            if !arViewModel.hasPlacedWave && arViewModel.surfaceDetected {
                VStack {
                    Spacer()
                        .frame(height: 100)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        
                        Text("Surface detected")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            arViewModel.updateBand(selectedBand)
        }
        .onChange(of: selectedBand) { _, newBand in
            arViewModel.updateBand(newBand)
        }
    }
    
    // MARK: - Wave Legend View
    private var waveLegendView: some View {
        VStack(spacing: 12) {
            // Title
            Text("Electromagnetic Wave")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                // Electric Field indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(selectedBand?.color ?? .red)
                        .frame(width: 12, height: 12)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("E Field")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Electric")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                // Magnetic Field indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(magneticFieldColor)
                        .frame(width: 12, height: 12)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("B Field")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Magnetic")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                // Propagation indicator
                HStack(spacing: 6) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Direction")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Propagation")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            
            // Wave info
            if let band = selectedBand {
                Text("λ = \(band.wavelength) • f = \(band.frequency)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(selectedBand?.color.opacity(0.3) ?? Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }
    
    private var magneticFieldColor: Color {
        guard let band = selectedBand else { return .cyan }
        // Shift the color towards cyan/blue for magnetic field
        return Color(UIColor { _ in
            let uiColor = UIColor(band.color)
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            let newHue = (hue + 0.3).truncatingRemainder(dividingBy: 1.0)
            return UIColor(hue: newHue, saturation: saturation * 0.8, brightness: brightness, alpha: alpha)
        })
    }
}

// MARK: - AR View Model
@MainActor
class ARViewModel: ObservableObject {
    @Published var hasPlacedWave = false
    @Published var isAnimating = true
    @Published var selectedBand: SpectrumBand?
    @Published var surfaceDetected = false
    
    weak var arView: ARView?
    private var waveAnchors: [AnchorEntity] = []
    private var cancellables = Set<AnyCancellable>()
    private var activeWaveCount = 0
    private let maxConcurrentWaves = 12  // Limit concurrent waves
    
    func updateBand(_ band: SpectrumBand?) {
        selectedBand = band
    }
    
    func placeWave(at transform: simd_float4x4) {
        guard let arView = arView, let band = selectedBand else { return }
        
        let anchor = AnchorEntity(world: transform)
        
        // Create realistic wave source with pulsing animation
        let sourcePoint = createRealisticSource(for: band)
        anchor.addChild(sourcePoint)
        
        // Start continuous sine wave visualization
        startWaveGeneration(on: anchor, band: band)
        
        arView.scene.addAnchor(anchor)
        waveAnchors.append(anchor)
        hasPlacedWave = true
        
        HapticFeedback.medium()
    }
    
    private func createRealisticSource(for band: SpectrumBand) -> Entity {
        let container = Entity()
        
        // Glowing core
        let core = ModelEntity(
            mesh: .generateSphere(radius: 0.02),
            materials: [createGlowMaterial(for: band)]
        )
        container.addChild(core)
        
        // Outer energy field
        let field = ModelEntity(
            mesh: .generateSphere(radius: 0.035),
            materials: [createFieldMaterial(for: band)]
        )
        container.addChild(field)
        
        // Pulse animation
        animatePulse(entity: field, baseScale: 1.0, maxScale: 1.3, duration: 1.5)
        
        return container
    }
    
    private func animatePulse(entity: Entity, baseScale: Float, maxScale: Float, duration: TimeInterval) {
        var transform = entity.transform
        transform.scale = SIMD3(repeating: maxScale)
        
        entity.move(to: transform, relativeTo: entity.parent, duration: duration, timingFunction: .easeInOut)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            var resetTransform = entity.transform
            resetTransform.scale = SIMD3(repeating: baseScale)
            entity.move(to: resetTransform, relativeTo: entity.parent, duration: duration, timingFunction: .easeInOut)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                if !self.waveAnchors.isEmpty {
                    self.animatePulse(entity: entity, baseScale: baseScale, maxScale: maxScale, duration: duration)
                }
            }
        }
    }
    
    private func startWaveGeneration(on anchor: AnchorEntity, band: SpectrumBand) {
        // Get band-specific wave properties
        let waveProperties = getWaveProperties(for: band)
        
        // Generate waves in multiple directions
        let directions: [SIMD3<Float>] = [
            SIMD3(1, 0, 0),   // Right
            SIMD3(-1, 0, 0),  // Left
            SIMD3(0, 0, 1),   // Forward
            SIMD3(0, 0, -1)   // Backward
        ]
        
        for (index, direction) in directions.enumerated() {
            let delay = Double(index) * waveProperties.directionDelay
            createTravelingWave(on: anchor, band: band, direction: direction, delay: delay, properties: waveProperties)
        }
    }
    
    private func getWaveProperties(for band: SpectrumBand) -> WaveProperties {
        switch band.name {
        case "Radio Waves":
            return WaveProperties(
                wavelength: 0.5,        // Very long wavelength
                amplitude: 0.08,        // Large amplitude
                particleCount: 15,      // Fewer particles (long wave)
                speed: 3.0,             // Slower
                particleSize: 0.012,    // Larger particles
                opacity: 0.6,
                directionDelay: 0.2,
                regenerationDelay: 1.0
            )
        case "Microwaves":
            return WaveProperties(
                wavelength: 0.4,
                amplitude: 0.06,
                particleCount: 20,
                speed: 2.8,
                particleSize: 0.010,
                opacity: 0.65,
                directionDelay: 0.18,
                regenerationDelay: 0.9
            )
        case "Infrared":
            return WaveProperties(
                wavelength: 0.3,
                amplitude: 0.05,
                particleCount: 25,
                speed: 2.6,
                particleSize: 0.009,
                opacity: 0.7,
                directionDelay: 0.15,
                regenerationDelay: 0.8
            )
        case "Visible Light":
            return WaveProperties(
                wavelength: 0.2,        // Medium wavelength
                amplitude: 0.04,        // Medium amplitude
                particleCount: 30,      // More particles
                speed: 2.4,
                particleSize: 0.008,
                opacity: 0.75,
                directionDelay: 0.12,
                regenerationDelay: 0.7
            )
        case "Ultraviolet":
            return WaveProperties(
                wavelength: 0.15,
                amplitude: 0.03,
                particleCount: 22,      // Reduced from 35
                speed: 2.2,
                particleSize: 0.007,
                opacity: 0.8,
                directionDelay: 0.15,   // Increased from 0.10
                regenerationDelay: 0.9  // Increased from 0.6
            )
        case "X-Rays":
            return WaveProperties(
                wavelength: 0.1,        // Short wavelength
                amplitude: 0.02,        // Small amplitude
                particleCount: 20,      // Reduced from 40
                speed: 2.0,
                particleSize: 0.006,    // Smaller particles
                opacity: 0.85,
                directionDelay: 0.18,   // Increased from 0.08
                regenerationDelay: 1.0  // Increased from 0.5
            )
        case "Gamma Rays":
            return WaveProperties(
                wavelength: 0.08,       // Shortest wavelength
                amplitude: 0.015,       // Smallest amplitude
                particleCount: 18,      // Reduced from 50
                speed: 1.8,
                particleSize: 0.005,    // Smallest particles
                opacity: 0.9,
                directionDelay: 0.20,   // Increased from 0.05
                regenerationDelay: 1.2  // Increased from 0.4
            )
        default:
            return WaveProperties(
                wavelength: 0.3,
                amplitude: 0.04,
                particleCount: 25,
                speed: 2.5,
                particleSize: 0.008,
                opacity: 0.7,
                directionDelay: 0.15,
                regenerationDelay: 0.8
            )
        }
    }
    
    private struct WaveProperties {
        let wavelength: Float
        let amplitude: Float
        let particleCount: Int
        let speed: TimeInterval
        let particleSize: Float
        let opacity: Double
        let directionDelay: TimeInterval
        let regenerationDelay: TimeInterval
    }
    
    private func createTravelingWave(on anchor: AnchorEntity, band: SpectrumBand, direction: SIMD3<Float>, delay: TimeInterval, properties: WaveProperties) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.isAnimating, !self.waveAnchors.isEmpty else { return }
            
            // Limit concurrent waves to prevent crashes
            guard self.activeWaveCount < self.maxConcurrentWaves else { return }
            
            self.activeWaveCount += 1
            
            // Create realistic 3D electromagnetic wave
            let waveContainer = Entity()
            
            // Create proper EM wave with Electric (E) and Magnetic (B) field components
            self.createElectromagneticWave(
                container: waveContainer,
                band: band,
                direction: direction,
                properties: properties
            )
            
            anchor.addChild(waveContainer)
            
            // Smooth outward propagation
            var moveTransform = waveContainer.transform
            moveTransform.translation = SIMD3(
                direction.x * 2.5,
                0,
                direction.z * 2.5
            )
            
            waveContainer.move(
                to: moveTransform,
                relativeTo: anchor,
                duration: properties.speed,
                timingFunction: .linear
            )
            
            // Fade out naturally
            DispatchQueue.main.asyncAfter(deadline: .now() + properties.speed * 0.9) {
                waveContainer.removeFromParent()
                self.activeWaveCount -= 1
            }
            
            // Continue generating waves with band-specific timing
            if self.isAnimating && !self.waveAnchors.isEmpty {
                self.createTravelingWave(on: anchor, band: band, direction: direction, delay: properties.regenerationDelay, properties: properties)
            }
        }
    }
    
    // MARK: - Realistic Electromagnetic Wave Creation
    private func createElectromagneticWave(container: Entity, band: SpectrumBand, direction: SIMD3<Float>, properties: WaveProperties) {
        let segmentCount = min(properties.particleCount, 24)
        let waveLength: Float = 1.8  // Total wave length in meters
        
        // Calculate perpendicular axes for E and B fields
        // E-field oscillates vertically (Y-axis)
        // B-field oscillates horizontally (perpendicular to both direction and E)
        let upVector = SIMD3<Float>(0, 1, 0)
        let bFieldDirection = normalize(cross(direction, upVector))
        
        // Create the central propagation axis (direction of travel)
        createPropagationAxis(container: container, direction: direction, length: waveLength, band: band, properties: properties)
        
        // Create Electric Field (E) - Vertical sinusoidal oscillation
        createFieldWave(
            container: container,
            direction: direction,
            oscillationAxis: upVector,
            segmentCount: segmentCount,
            waveLength: waveLength,
            amplitude: properties.amplitude,
            band: band,
            properties: properties,
            isElectricField: true,
            phaseOffset: 0
        )
        
        // Create Magnetic Field (B) - Horizontal sinusoidal oscillation (90° out of phase spatially)
        createFieldWave(
            container: container,
            direction: direction,
            oscillationAxis: bFieldDirection,
            segmentCount: segmentCount,
            waveLength: waveLength,
            amplitude: properties.amplitude * 0.8,
            band: band,
            properties: properties,
            isElectricField: false,
            phaseOffset: 0
        )
        
        // Add wave source glow at origin
        let sourceGlow = ModelEntity(
            mesh: .generateSphere(radius: properties.particleSize * 2),
            materials: [createGlowMaterial(for: band)]
        )
        container.addChild(sourceGlow)
    }
    
    private func createPropagationAxis(container: Entity, direction: SIMD3<Float>, length: Float, band: SpectrumBand, properties: WaveProperties) {
        // Create dotted line showing direction of propagation
        let dotCount = 12
        let spacing = length / Float(dotCount)
        
        for i in 0..<dotCount {
            let dot = ModelEntity(
                mesh: .generateSphere(radius: properties.particleSize * 0.4),
                materials: [createAxisMaterial(for: band)]
            )
            let distance = Float(i) * spacing
            dot.position = SIMD3(
                direction.x * distance,
                0,
                direction.z * distance
            )
            container.addChild(dot)
        }
    }
    
    private func createFieldWave(
        container: Entity,
        direction: SIMD3<Float>,
        oscillationAxis: SIMD3<Float>,
        segmentCount: Int,
        waveLength: Float,
        amplitude: Float,
        band: SpectrumBand,
        properties: WaveProperties,
        isElectricField: Bool,
        phaseOffset: Float
    ) {
        // Create smooth sinusoidal wave using connected spheres
        var previousPosition: SIMD3<Float>? = nil
        
        for i in 0..<segmentCount {
            let t = Float(i) / Float(segmentCount - 1)
            let distance = t * waveLength
            
            // Calculate sine wave position
            let phase = (distance / properties.wavelength) * 2 * .pi + phaseOffset
            let oscillation = sin(phase) * amplitude
            
            // Position along propagation direction + oscillation
            let position = SIMD3(
                direction.x * distance + oscillationAxis.x * oscillation,
                oscillationAxis.y * oscillation,
                direction.z * distance + oscillationAxis.z * oscillation
            )
            
            // Create wave particle
            let particleSize = properties.particleSize * (isElectricField ? 1.0 : 0.8)
            let particle = ModelEntity(
                mesh: .generateSphere(radius: particleSize),
                materials: [isElectricField ? 
                    createElectricFieldMaterial(for: band, opacity: properties.opacity) :
                    createMagneticFieldMaterial(for: band, opacity: properties.opacity * 0.7)]
            )
            particle.position = position
            container.addChild(particle)
            
            // Create connecting line segments between particles for smooth wave appearance
            if let prevPos = previousPosition, i % 2 == 0 {
                createWaveSegment(
                    container: container,
                    from: prevPos,
                    to: position,
                    band: band,
                    isElectricField: isElectricField,
                    properties: properties
                )
            }
            
            // Add field lines (arrows) at peaks and troughs to show field direction
            if i > 0 && i < segmentCount - 1 && i % 4 == 0 {
                let fieldStrength = abs(sin(phase))
                if fieldStrength > 0.7 {
                    createFieldArrow(
                        container: container,
                        position: SIMD3(direction.x * distance, 0, direction.z * distance),
                        direction: oscillationAxis * (sin(phase) > 0 ? 1 : -1),
                        length: amplitude * 0.6,
                        band: band,
                        isElectricField: isElectricField,
                        properties: properties
                    )
                }
            }
            
            previousPosition = position
        }
        
        // Add field label at the end
        addFieldLabel(
            container: container,
            position: SIMD3(
                direction.x * waveLength * 0.5,
                isElectricField ? amplitude * 1.5 : 0,
                direction.z * waveLength * 0.5 + (isElectricField ? 0 : amplitude * 1.5)
            ),
            isElectricField: isElectricField,
            band: band,
            properties: properties
        )
    }
    
    private func createWaveSegment(container: Entity, from: SIMD3<Float>, to: SIMD3<Float>, band: SpectrumBand, isElectricField: Bool, properties: WaveProperties) {
        let midpoint = (from + to) / 2
        let length = simd_length(to - from)
        
        guard length > 0.001 else { return }
        
        let segment = ModelEntity(
            mesh: .generateBox(size: SIMD3(properties.particleSize * 0.5, properties.particleSize * 0.5, length)),
            materials: [isElectricField ?
                createElectricFieldMaterial(for: band, opacity: properties.opacity * 0.6) :
                createMagneticFieldMaterial(for: band, opacity: properties.opacity * 0.4)]
        )
        
        segment.position = midpoint
        
        // Orient segment to point from 'from' to 'to'
        let direction = normalize(to - from)
        segment.look(at: to, from: midpoint, relativeTo: nil)
        
        container.addChild(segment)
    }
    
    private func createFieldArrow(container: Entity, position: SIMD3<Float>, direction: SIMD3<Float>, length: Float, band: SpectrumBand, isElectricField: Bool, properties: WaveProperties) {
        // Arrow shaft
        let shaft = ModelEntity(
            mesh: .generateBox(size: SIMD3(properties.particleSize * 0.3, length * 0.8, properties.particleSize * 0.3)),
            materials: [isElectricField ?
                createElectricFieldMaterial(for: band, opacity: properties.opacity * 0.5) :
                createMagneticFieldMaterial(for: band, opacity: properties.opacity * 0.4)]
        )
        
        shaft.position = position + direction * (length * 0.4)
        container.addChild(shaft)
        
        // Arrow head (cone approximated with small sphere)
        let head = ModelEntity(
            mesh: .generateSphere(radius: properties.particleSize * 0.8),
            materials: [isElectricField ?
                createElectricFieldMaterial(for: band, opacity: properties.opacity * 0.8) :
                createMagneticFieldMaterial(for: band, opacity: properties.opacity * 0.6)]
        )
        head.position = position + direction * length * 0.8
        container.addChild(head)
    }
    
    private func addFieldLabel(container: Entity, position: SIMD3<Float>, isElectricField: Bool, band: SpectrumBand, properties: WaveProperties) {
        // Create a small indicator sphere to mark E or B field
        let indicator = ModelEntity(
            mesh: .generateSphere(radius: properties.particleSize * 1.2),
            materials: [isElectricField ?
                createElectricFieldMaterial(for: band, opacity: 0.9) :
                createMagneticFieldMaterial(for: band, opacity: 0.7)]
        )
        indicator.position = position
        container.addChild(indicator)
    }
    
    // MARK: - Materials
    private func createElectricFieldMaterial(for band: SpectrumBand, opacity: Double) -> SimpleMaterial {
        var material = SimpleMaterial()
        // Electric field uses the band's primary color
        material.color = .init(tint: UIColor(band.color.opacity(opacity)))
        material.roughness = .float(0.05)
        material.metallic = .float(0.9)
        return material
    }
    
    private func createMagneticFieldMaterial(for band: SpectrumBand, opacity: Double) -> SimpleMaterial {
        var material = SimpleMaterial()
        // Magnetic field uses a complementary/shifted color (more blue-ish)
        let magneticColor = shiftColorForMagneticField(band.color)
        material.color = .init(tint: UIColor(magneticColor.opacity(opacity)))
        material.roughness = .float(0.1)
        material.metallic = .float(0.7)
        return material
    }
    
    private func createAxisMaterial(for band: SpectrumBand) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(Color.white.opacity(0.3)))
        material.roughness = .float(0.5)
        material.metallic = .float(0.2)
        return material
    }
    
    private func shiftColorForMagneticField(_ color: Color) -> Color {
        // Shift the color towards cyan/blue for magnetic field visualization
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Shift hue towards blue (0.6 in HSB)
        let newHue = (hue + 0.3).truncatingRemainder(dividingBy: 1.0)
        
        return Color(UIColor(hue: newHue, saturation: saturation * 0.8, brightness: brightness, alpha: alpha))
    }
    
    private func createGlowMaterial(for band: SpectrumBand) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(band.color))
        material.roughness = .float(0.0)
        material.metallic = .float(1.0)
        return material
    }
    
    private func createFieldMaterial(for band: SpectrumBand) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(band.color.opacity(0.2)))
        material.roughness = .float(0.1)
        material.metallic = .float(0.3)
        return material
    }
    
    private func createWaveMaterial(for band: SpectrumBand, opacity: Double) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(band.color.opacity(opacity)))
        material.roughness = .float(0.1)
        material.metallic = .float(0.8)
        return material
    }
    
    private func createTrailMaterial(for band: SpectrumBand) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(band.color.opacity(0.15)))
        material.roughness = .float(0.0)
        material.metallic = .float(0.5)
        return material
    }
    
    private func createRingMaterial(for band: SpectrumBand, opacity: Double) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(band.color.opacity(opacity)))
        material.roughness = .float(0.3)
        return material
    }
    
    func clearAllWaves() {
        guard let arView = arView else { return }
        
        // Stop animations
        isAnimating = false
        
        // Remove all anchors and their children
        for anchor in waveAnchors {
            anchor.children.forEach { $0.removeFromParent() }
            arView.scene.removeAnchor(anchor)
        }
        waveAnchors.removeAll()
        hasPlacedWave = false
        activeWaveCount = 0
        
        // Restart animations after cleanup
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isAnimating = true
        }
        
        HapticFeedback.light()
    }
    
    func toggleAnimation() {
        isAnimating.toggle()
        HapticFeedback.light()
    }
}

// MARK: - AR View Container
struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var arViewModel: ARViewModel
    let selectedBand: SpectrumBand?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics.insert(.sceneDepth)
        }
        
        arView.session.run(config)
        arView.environment.sceneUnderstanding.options = []
        
        // Store reference
        arViewModel.arView = arView
        arViewModel.updateBand(selectedBand)
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        context.coordinator.arView = arView
        context.coordinator.viewModel = arViewModel
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arViewModel: arViewModel)
    }
    
    class Coordinator: NSObject {
        var arView: ARView?
        var viewModel: ARViewModel?
        var cancellables = Set<AnyCancellable>()
        private var planeDetectionTimer: Timer?
        
        init(arViewModel: ARViewModel) {
            self.viewModel = arViewModel
            super.init()
            
            // Use timer instead of SceneEvents to avoid publishing during view updates
            planeDetectionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                guard let self = self, let arView = self.arView else { return }
                let hasPlanes = !arView.scene.anchors.isEmpty
                Task { @MainActor in
                    self.viewModel?.surfaceDetected = hasPlanes
                }
            }
        }
        
        deinit {
            planeDetectionTimer?.invalidate()
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = arView, let viewModel = viewModel else { return }
            
            let location = gesture.location(in: arView)
            
            // Prioritize existing plane geometry
            var results = arView.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .any)
            
            if results.isEmpty {
                results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
            }
            
            // Fallback to fixed distance
            if results.isEmpty {
                guard let cameraTransform = arView.session.currentFrame?.camera.transform else { return }
                
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -0.5  // 0.5m in front
                let worldTransform = matrix_multiply(cameraTransform, translation)
                
                Task { @MainActor in
                    viewModel.placeWave(at: worldTransform)
                }
            } else if let result = results.first {
                Task { @MainActor in
                    viewModel.placeWave(at: result.worldTransform)
                }
            }
        }
    }
}
