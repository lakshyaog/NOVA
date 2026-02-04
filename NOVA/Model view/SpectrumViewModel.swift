import SwiftUI
import Combine

@MainActor
class SpectrumViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedBand: SpectrumBand?
    @Published var showingInfo = false
    @Published var animateWaves = false
    @Published var glowIntensity = 0.0
    @Published var showingARView = false
    
    // MARK: - Constants
    let bands = SpectrumBand.sampleBands
    
    // MARK: - Methods
    func selectBand(_ band: SpectrumBand) {
        // Immediate haptic feedback
        HapticFeedback.light()
        
        // Use Task to update state immediately on main actor, avoiding "Publishing changes" error
        Task { @MainActor in
            if selectedBand == band {
                selectedBand = nil
            } else {
                selectedBand = band
            }
        }
    }
    
    func toggleInfo() {
        HapticFeedback.light() 
        showingInfo.toggle()
    }
    
    func toggleWaveAnimation() {
        HapticFeedback.light()
        animateWaves.toggle()
    }
    
    func toggleARView() {
        HapticFeedback.light()
        showingARView.toggle()
    }
    
    func startInitialAnimations() {
        // Start with stable glow intensity
        glowIntensity = 0.7
        
        // Delayed animations to avoid interference
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                self.glowIntensity = 0.8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.animateWaves = true
        }
    }
}
