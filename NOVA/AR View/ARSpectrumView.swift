import SwiftUI
import ARKit
import RealityKit
import Combine

struct ARSpectrumView: View {
    let selectedBand: SpectrumBand?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var arViewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel, selectedBand: selectedBand)
                .ignoresSafeArea()
            
            VStack {
                // Minimalist top bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    if let band = selectedBand {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(band.color)
                                .frame(width: 8, height: 8)
                            
                            Text(band.name)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.4))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(band.color.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
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
                particleCount: 35,
                speed: 2.2,
                particleSize: 0.007,
                opacity: 0.8,
                directionDelay: 0.10,
                regenerationDelay: 0.6
            )
        case "X-Rays":
            return WaveProperties(
                wavelength: 0.1,        // Short wavelength
                amplitude: 0.02,        // Small amplitude
                particleCount: 40,      // Many particles
                speed: 2.0,             // Faster
                particleSize: 0.006,    // Smaller particles
                opacity: 0.85,
                directionDelay: 0.08,
                regenerationDelay: 0.5
            )
        case "Gamma Rays":
            return WaveProperties(
                wavelength: 0.08,       // Shortest wavelength
                amplitude: 0.015,       // Smallest amplitude
                particleCount: 50,      // Most particles (tight wave)
                speed: 1.8,             // Fastest
                particleSize: 0.005,    // Smallest particles
                opacity: 0.9,
                directionDelay: 0.05,
                regenerationDelay: 0.4
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
            guard self.isAnimating else { return }
            
            // Create realistic 3D sine wave
            let waveContainer = Entity()
            
            // Reduce particle count for better performance
            let optimizedCount = min(properties.particleCount, 30)
            
            // Create connected wave path
            for i in 0..<optimizedCount {
                let particle = ModelEntity(
                    mesh: .generateSphere(radius: properties.particleSize),
                    materials: [self.createWaveMaterial(for: band, opacity: properties.opacity)]
                )
                
                // Position along the wave direction
                let t = Float(i) / Float(optimizedCount)
                let distance = t * 2.0  // Extended wave length for visibility
                
                // Calculate 3D sine wave position
                let angle = (distance / properties.wavelength) * 2 * .pi
                let verticalOffset = sin(angle) * properties.amplitude
                
                // Add perpendicular oscillation for 3D effect
                let perpendicularAngle = angle + .pi / 2
                let sideOffset = cos(perpendicularAngle) * (properties.amplitude * 0.5)
                
                // Calculate perpendicular direction (cross product with up vector)
                let perpDir = normalize(cross(direction, SIMD3<Float>(0, 1, 0)))
                
                // Set 3D position
                particle.position = SIMD3(
                    direction.x * distance + perpDir.x * sideOffset,
                    verticalOffset,
                    direction.z * distance + perpDir.z * sideOffset
                )
                
                waveContainer.addChild(particle)
                
                // Reduce trail particles for performance - only every 3rd particle
                if i > 5 && i < optimizedCount - 5 && i % 3 == 0 {
                    let trail = ModelEntity(
                        mesh: .generateSphere(radius: properties.particleSize * 1.5),
                        materials: [self.createTrailMaterial(for: band)]
                    )
                    trail.position = particle.position
                    waveContainer.addChild(trail)
                }
            }
            
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
            
            // Fade out naturally - simplified for performance
            DispatchQueue.main.asyncAfter(deadline: .now() + properties.speed * 0.9) {
                waveContainer.removeFromParent()
            }
            
            // Continue generating waves with band-specific timing
            if self.isAnimating && !self.waveAnchors.isEmpty {
                self.createTravelingWave(on: anchor, band: band, direction: direction, delay: properties.regenerationDelay, properties: properties)
            }
        }
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
        
        for anchor in waveAnchors {
            arView.scene.removeAnchor(anchor)
        }
        waveAnchors.removeAll()
        hasPlacedWave = false
        
        // Restart animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
