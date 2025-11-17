import SwiftUI
import ARKit
import RealityKit

struct ARSpectrumView: View {
    let selectedBand: SpectrumBand?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var arViewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel, selectedBand: selectedBand)
                .ignoresSafeArea()
            
            VStack {
                // Top bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 4)
                    }
                    .padding()
                    
                    Spacer()
                    
                    if let band = selectedBand {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(band.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Text("AR Mode")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.6))
                        )
                        .padding()
                    }
                }
                
                Spacer()
                
                // Instructions
                VStack(spacing: 12) {
                    if !arViewModel.hasPlacedWave {
                        Text("Tap anywhere to place EM wave")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.7))
                            )
                    }
                    
                    // Controls
                    HStack(spacing: 16) {
                        Button {
                            arViewModel.clearAllWaves()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "trash")
                                    .font(.system(size: 14))
                                Text("Clear")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.7))
                            )
                        }
                        
                        Button {
                            arViewModel.toggleAnimation()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: arViewModel.isAnimating ? "pause.fill" : "play.fill")
                                    .font(.system(size: 14))
                                Text(arViewModel.isAnimating ? "Pause" : "Play")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.7))
                            )
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            arViewModel.updateBand(selectedBand)
            print("🔵 ARSpectrumView appeared with band: \(selectedBand?.name ?? "nil")")
        }
        .onChange(of: selectedBand) { _, newBand in
            arViewModel.updateBand(newBand)
            print("🔵 Band changed to: \(newBand?.name ?? "nil")")
        }
    }
}

// MARK: - AR View Model
@MainActor
class ARViewModel: ObservableObject {
    @Published var hasPlacedWave = false
    @Published var isAnimating = true
    @Published var selectedBand: SpectrumBand?
    
    weak var arView: ARView?
    private var waveAnchors: [AnchorEntity] = []
    
    func updateBand(_ band: SpectrumBand?) {
        selectedBand = band
        print("🟢 ARViewModel band updated to: \(band?.name ?? "nil")")
    }
    
    func placeWave(at transform: simd_float4x4) {
        guard let arView = arView, let band = selectedBand else { 
            print("⚠️ Cannot place wave - arView or band is nil")
            return 
        }
        
        print("✅ Placing wave for band: \(band.name)")
        
        let anchor = AnchorEntity(world: transform)
        
        // Create wave source sphere - smaller and more realistic
        let sourceSphere = ModelEntity(
            mesh: .generateSphere(radius: 0.05),
            materials: [createMaterial(for: band, opacity: 0.9)]
        )
        anchor.addChild(sourceSphere)
        
        print("✅ Created source sphere")
        
        // Start continuous wave generation
        startContinuousWaves(anchor: anchor, color: band.color)
        
        arView.scene.addAnchor(anchor)
        waveAnchors.append(anchor)
        hasPlacedWave = true
        
        print("✅ Wave placed successfully - total anchors: \(waveAnchors.count)")
        
        HapticFeedback.medium()
    }
    
    private func startContinuousWaves(anchor: AnchorEntity, color: Color) {
        guard isAnimating else { return }
        
        // Create one wave ring
        let ring = ModelEntity(
            mesh: .generateBox(size: [0.2, 0.01, 0.2]),
            materials: [createRingMaterial(color: color)]
        )
        
        anchor.addChild(ring)
        
        // Animate ring expansion and fade
        var transform = ring.transform
        transform.scale = SIMD3<Float>(2.5, 1, 2.5)
        
        ring.move(to: transform, relativeTo: anchor, duration: 1.5, timingFunction: .easeOut)
        
        // Remove after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            ring.removeFromParent()
        }
        
        // Schedule next wave
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if self.isAnimating && !self.waveAnchors.isEmpty {
                self.startContinuousWaves(anchor: anchor, color: color)
            }
        }
    }
    
    private func createRingMaterial(color: Color) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(color.opacity(0.5)))
        return material
    }
    
    private func createMaterial(for band: SpectrumBand, opacity: Float) -> SimpleMaterial {
        var material = SimpleMaterial()
        material.color = .init(tint: UIColor(band.color.opacity(Double(opacity))))
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
        
        // Configure AR session with better tracking
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        
        // Enable better tracking
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics.insert(.sceneDepth)
        }
        
        arView.session.run(config)
        
        // Disable default plane visualization for cleaner look
        arView.environment.sceneUnderstanding.options = []
        
        // Store reference
        arViewModel.arView = arView
        
        // Update band when view is created
        arViewModel.updateBand(selectedBand)
        print("🔷 ARView created with band: \(selectedBand?.name ?? "nil")")
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        context.coordinator.arView = arView
        
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
        var arViewModel: ARViewModel
        
        init(arViewModel: ARViewModel) {
            self.arViewModel = arViewModel
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = arView else { 
                print("⚠️ ARView is nil")
                return 
            }
            
            print("👆 Tap detected!")
            
            let location = gesture.location(in: arView)
            
            // Try multiple raycast methods for better detection
            var results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
            
            print("📍 Estimated plane results: \(results.count)")
            
            // If no results, try existing planes
            if results.isEmpty {
                results = arView.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .any)
                print("📍 Existing plane results: \(results.count)")
            }
            
            // If still no results, create at a fixed distance
            if results.isEmpty {
                print("📍 No planes found, placing 1m in front of camera")
                // Get camera transform
                guard let cameraTransform = arView.session.currentFrame?.camera.transform else { 
                    print("⚠️ Camera transform is nil")
                    return 
                }
                
                // Calculate position 1 meter in front of camera
                let translation = simd_make_float4(0, 0, -1, 0)
                let position = matrix_multiply(cameraTransform, translation)
                
                var worldTransform = matrix_identity_float4x4
                worldTransform.columns.3 = simd_make_float4(position.x, position.y, position.z, 1)
                
                Task { @MainActor in
                    arViewModel.placeWave(at: worldTransform)
                }
            } else if let result = results.first {
                print("📍 Using raycast result")
                Task { @MainActor in
                    arViewModel.placeWave(at: result.worldTransform)
                }
            }
        }
    }
}
