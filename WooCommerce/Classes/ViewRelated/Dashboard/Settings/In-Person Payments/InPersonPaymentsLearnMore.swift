import SwiftUI

struct InPersonPaymentsLearnMore: View {
    static let learnMoreURL = URL(string: "woocommerce://in-person-payments/learn-more")!
    @Environment(\.customOpenURL) var customOpenURL

    let url: URL
    let linkText: String
    let formatText: String
    let analyticReason: String?

    init(url: URL = learnMoreURL,
         linkText: String = Localization.learnMoreLink,
         formatText: String = Localization.learnMoreText,
         analyticReason: String? = nil) {
        self.url = url
        self.linkText = linkText
        self.formatText = formatText
        self.analyticReason = analyticReason
    }

    private let cardPresentConfiguration = CardPresentConfigurationLoader().configuration

    var body: some View {
        HStack(spacing: 16) {
            Image(uiImage: .infoOutlineImage)
                .resizable()
                .foregroundColor(Color(.neutral(.shade60)))
                .frame(width: iconSize, height: iconSize)
            AttributedText(learnMoreAttributedString)
        }
            .padding(.vertical, Constants.verticalPadding)
            .onTapGesture {
                ServiceLocator.analytics.track(
                    event: WooAnalyticsEvent.InPersonPayments.cardPresentOnboardingLearnMoreTapped(
                        reason: analyticReason ?? "",
                        countryCode: cardPresentConfiguration.countryCode))
                customOpenURL?(url)
            }
    }

    var iconSize: CGFloat {
        UIFontMetrics(forTextStyle: .subheadline).scaledValue(for: 20)
    }

    private var learnMoreAttributedString: NSAttributedString {
        let result = NSMutableAttributedString(
            string: .localizedStringWithFormat(formatText, linkText),
            attributes: [.foregroundColor: UIColor.textSubtle]
        )
        result.replaceFirstOccurrence(
            of: linkText,
            with: NSAttributedString(
                string: linkText,
                attributes: [.foregroundColor: UIColor.textLink]
            ))

        // https://github.com/gonzalezreal/AttributedText/issues/11
        result.addAttribute(.font, value: UIFont.footnote, range: NSRange(location: 0, length: result.length))
        return result
    }
}

private enum Constants {
    static let verticalPadding: CGFloat = 8
}

private enum Localization {
    static let unavailable = NSLocalizedString(
        "In-Person Payments is currently unavailable",
        comment: "Title for the error screen when In-Person Payments is unavailable"
    )

    static let acceptCash = NSLocalizedString(
        "You can still accept in-person cash payments by enabling the “Cash on Delivery” payment method on your store.",
        comment: "Generic error message when In-Person Payments is unavailable"
    )

    static let learnMoreLink = NSLocalizedString(
        "Learn more",
        comment: """
                 A label prompting users to learn more about card readers.
                 This part is the link to the website, and forms part of a longer sentence which it should be considered a part of.
                 """
    )

    static let learnMoreText = NSLocalizedString(
        "%1$@ about accepting payments with your mobile device and ordering card readers",
        comment: """
                 A label prompting users to learn more about card readers"
                 %1$@ is a placeholder that always replaced with \"Learn more\" string,
                 which should be translated separately and considered part of this sentence.
                 """
    )
}

struct InPersonPaymentsLearnMore_Previews: PreviewProvider {
    static var previews: some View {
        InPersonPaymentsLearnMore()
            .padding()
    }
}
