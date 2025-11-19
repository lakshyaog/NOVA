import SwiftUI

struct MainHeaderView: View {
    @Binding var showingInfo: Bool
    let onInfoTap: () -> Void
    var onARTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("EM Spectrum")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Explore the Electromagnetic Spectrum")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                if let onARTap = onARTap {
                    Button {
                        HapticFeedback.light()
                        onARTap()
                    } label: {
                        Image(systemName: "arkit")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                Button {
                    HapticFeedback.light()
                    onInfoTap()
                } label: {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.top, 50)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}
