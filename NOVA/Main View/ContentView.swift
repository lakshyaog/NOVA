import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SpectrumViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        MainHeaderView(
                            showingInfo: $viewModel.showingInfo,
                            onInfoTap: viewModel.toggleInfo
                        )
                        .padding(.top, geometry.safeAreaInsets.top > 0 ? 10 : 20)
                        
                        SpectrumBandsScrollView(
                            bands: viewModel.bands,
                            selectedBand: viewModel.selectedBand,
                            glowIntensity: viewModel.glowIntensity,
                            onBandTap: viewModel.selectBand
                        )
                        .padding(.top, 10)
                        
                        DetailOrWelcomeView(selectedBand: viewModel.selectedBand)
                            .padding(.horizontal, 16)
                        
                        WaveVisualizerView(
                            selectedBand: viewModel.selectedBand,
                            animate: viewModel.animateWaves,
                            onTap: viewModel.toggleWaveAnimation
                        )
                        .padding(.horizontal, 16)
                        
                        PenetrationPower(selectedBand: viewModel.selectedBand)
                            .padding(.horizontal, 16)
                        DiscoveryTimeline(selectedBand: viewModel.selectedBand)
                            .padding(.horizontal, 16)
                        
                        Spacer(minLength: geometry.safeAreaInsets.bottom + 20)
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.startInitialAnimations()
        }
        .sheet(isPresented: $viewModel.showingInfo) {
            InfoView()
        }
    }
}

// MARK: - Supporting Views
struct SpectrumBandsScrollView: View {
    let bands: [SpectrumBand]
    let selectedBand: SpectrumBand?
    let glowIntensity: Double
    let onBandTap: (SpectrumBand) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(bands) { band in
                    SpectrumBandView(
                        band: band,
                        isSelected: selectedBand == band,
                        glowIntensity: glowIntensity
                    )
                    .onTapGesture {
                        HapticFeedback.light()
                        onBandTap(band)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct DetailOrWelcomeView: View {
    let selectedBand: SpectrumBand?
    
    var body: some View {
        Group {
            if let band = selectedBand {
                DetailView(band: band)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity.combined(with: .scale(scale: 0.9))
                    ))
            } else {
                WelcomeView()
                    .transition(.opacity)
            }
        }
    }
}


