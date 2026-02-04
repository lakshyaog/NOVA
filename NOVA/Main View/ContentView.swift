import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SpectrumViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Spectrum View
            MainSpectrumView(viewModel: viewModel)
                .tabItem {
                    Label("Spectrum", systemImage: "wave.3.right")
                }
                .tag(0)
            
            // AR View
            ARSpectrumView(selectedBand: viewModel.selectedBand)
                .tabItem {
                    Label("AR View", systemImage: "arkit")
                }
                .tag(1)
            
            // Info View
            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
                .tag(2)
        }
        .onAppear {
            viewModel.startInitialAnimations()
        }
    }
}

// MARK: - Main Spectrum View
struct MainSpectrumView: View {
    @ObservedObject var viewModel: SpectrumViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnimatedBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        MainHeaderView(
                            showingInfo: $viewModel.showingInfo,
                            onInfoTap: viewModel.toggleInfo,
                            onARTap: viewModel.toggleARView
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
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                onBandTap(band)
                            }
                    )
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
                    .id(band.id) // Force view recreation when band changes
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity.combined(with: .scale(scale: 0.9))
                    ))
            } else {
                WelcomeView()
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedBand?.id)
    }
}


