import SwiftUI

struct AnimatedBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [Color.black, Color.gray.opacity(0.3)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
