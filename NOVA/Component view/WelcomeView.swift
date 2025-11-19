import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            VStack(spacing: 8) {
                Text("Welcome to NOVA")
                    .font(.system(size: 44, weight: .semibold))
                    .bold()
                
                Text("Select a spectrum band to begin")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}
