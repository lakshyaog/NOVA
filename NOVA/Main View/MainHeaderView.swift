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
                
                Text("Explore the invisible")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                if let onARTap = onARTap {
                    Button {
                        HapticFeedback.light()
                        onARTap()
                    } label: {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }
                }
                
                Button {
                    HapticFeedback.light()
                    onInfoTap()
                } label: {
                    Image(systemName: showingInfo ? "info.circle.fill" : "info.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.top, 50)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}
