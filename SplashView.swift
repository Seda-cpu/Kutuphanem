import SwiftUI

struct SplashView: View {

    @Binding var showSplash: Bool

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Image("appIconSplash")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .shadow(radius: 10)

            Text("Ayraç")
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.pink, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("Kitap Listesi ve Okuma Takibi")
                .font(.title3)
                .fontWeight(.semibold)

            Text("""
Okuduğun, okumak istediğin ve bitirdiğin tüm kitapları
tek bir yerde takip et. İstatistiklerinle
okuma alışkanlığını geliştir.
""")
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)

            Spacer()

        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 0.6)) {
                    showSplash = false
                }
            }
        }
        .scaleEffect(showSplash ? 1 : 0.9)
        .opacity(showSplash ? 1 : 0)
    }
}
