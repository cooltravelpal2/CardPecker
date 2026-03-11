import SwiftUI

struct CouponBookView: View {
    var body: some View {
        ContentUnavailableView {
            Label("tab.couponBook".loc, systemImage: "ticket")
        } description: {
            Text("coupon.comingSoon".loc)
        }
        .navigationTitle("nav.couponBook".loc)
    }
}
