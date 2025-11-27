import SwiftUI

struct MainHeaderView: View {
    @Binding var showingInfo: Bool
    let onInfoTap: () -> Void
    var onARTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("EM Spectrum")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
            
            Text("Explore the Electromagnetic Spectrum")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 50)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}
