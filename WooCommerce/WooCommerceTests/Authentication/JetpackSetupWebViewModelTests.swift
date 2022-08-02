import XCTest
@testable import WooCommerce

final class JetpackSetupWebViewModelTests: XCTestCase {

    func test_initial_url_is_correct() {
        // Given
        let siteURL = "https://test.com"
        let viewModel = JetpackSetupWebViewModel(siteURL: siteURL, onCompletion: {_ in })

        // Then
        let expectedURL = "https://wordpress.com/jetpack/connect?url=https://test.com&mobile_redirect=woocommerce://jetpack-connected&from=mobile"
        XCTAssertEqual(viewModel.initialURL?.absoluteString, expectedURL)
    }

    func test_completion_handler_is_called_when_navigating_to_mobile_redirect() throws {
        // Given
        let siteURL = "https://test.com"
        var triggeredCompletion = false
        let completionHandler: (String?) -> Void = { _ in
            triggeredCompletion = true
        }
        let viewModel = JetpackSetupWebViewModel(siteURL: siteURL, onCompletion: completionHandler)

        // When
        let url = try XCTUnwrap(URL(string: "woocommerce://jetpack-connected"))
        viewModel.decidePolicy(for: url, decisionHandler: { _ in })

        // Then
        XCTAssertTrue(triggeredCompletion)
    }

    func test_completion_handler_returns_the_connected_email_from_url_query() throws {
        // Given
        let siteURL = "https://test.com"
        let expectedEmail = "test@mail.com"
        var authorizedEmail: String?
        let completionHandler: (String?) -> Void = { email in
            authorizedEmail = email
        }
        let viewModel = JetpackSetupWebViewModel(siteURL: siteURL, onCompletion: completionHandler)

        // When
        let authorizeURL = try XCTUnwrap(URL(string: "https://jetpack.wordpress.com/jetpack.authorize?user_email=\(expectedEmail)"))
        viewModel.decidePolicy(for: authorizeURL, decisionHandler: { _ in })
        let finalUrl = try XCTUnwrap(URL(string: "woocommerce://jetpack-connected"))
        viewModel.decidePolicy(for: finalUrl, decisionHandler: { _ in })

        // Then
        XCTAssertEqual(authorizedEmail, expectedEmail)
    }

    func test_dismissal_is_tracked() throws {
        // Given
        let siteURL = "https://test.com"
        let analyticsProvider = MockAnalyticsProvider()
        let analytics = WooAnalytics(analyticsProvider: analyticsProvider)
        let viewModel = JetpackSetupWebViewModel(siteURL: siteURL, analytics: analytics, onCompletion: { _ in })

        // When
        viewModel.handleDismissal()

        // Then
        let indexOfEvent = try XCTUnwrap(analyticsProvider.receivedEvents.firstIndex(where: { $0 == "login_jetpack_setup_dismissed" }))
        let properties = try XCTUnwrap(analyticsProvider.receivedProperties[indexOfEvent])
        XCTAssertEqual(properties["source"] as? String, "web")
    }

    func test_completion_is_tracked() throws {
        // Given
        let siteURL = "https://test.com"
        let analyticsProvider = MockAnalyticsProvider()
        let analytics = WooAnalytics(analyticsProvider: analyticsProvider)
        let viewModel = JetpackSetupWebViewModel(siteURL: siteURL, analytics: analytics, onCompletion: { _ in })

        // When
        let url = try XCTUnwrap(URL(string: "woocommerce://jetpack-connected"))
        viewModel.decidePolicy(for: url, decisionHandler: { _ in })

        // Then
        let indexOfEvent = try XCTUnwrap(analyticsProvider.receivedEvents.firstIndex(where: { $0 == "login_jetpack_setup_completed" }))
        let properties = try XCTUnwrap(analyticsProvider.receivedProperties[indexOfEvent])
        XCTAssertEqual(properties["source"] as? String, "web")
    }
}
