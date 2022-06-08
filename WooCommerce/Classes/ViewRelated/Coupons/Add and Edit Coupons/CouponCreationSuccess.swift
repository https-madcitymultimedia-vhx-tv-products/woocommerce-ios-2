import SwiftUI

/// A view to be displayed when a coupon is created successfully.
///
struct CouponCreationSuccess: View {
    let couponCode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Image(uiImage: UIImage.checkSuccessImage)
                    .padding(.bottom, Constants.imageBottomSpacing)
                Text(Localization.successMessage)
                    .font(.largeTitle)
                    .bold()
                Text(couponCode)
                    .font(.largeTitle)
            }
        }
    }
}

private extension CouponCreationSuccess {
    enum Constants {
        static let imageBottomSpacing: CGFloat = 40
    }

    enum Localization {
        static let successMessage = NSLocalizedString("Your new coupon was created!", comment: "Message displayed when a coupon was successfully created")
    }
}

struct CouponCreationSuccess_Previews: PreviewProvider {
    static var previews: some View {
        CouponCreationSuccess(couponCode: "34sdfg")
    }
}
