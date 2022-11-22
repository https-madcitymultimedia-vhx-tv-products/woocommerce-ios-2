import Foundation
import XCTest
import TestKit

@testable import WooCommerce

/// Test cases for `LoginJetpackSetupHostingController`.
///
final class LoginJetpackSetupHostingControllerTests: XCTestCase {
    private let testURL = "https://test.com"

    func test_it_tracks_login_jetpack_install_screen_viewed_when_view_loads() throws {
        // Given
        let analyticsProvider = MockAnalyticsProvider()
        let analytics = WooAnalytics(analyticsProvider: analyticsProvider)
        let viewController = LoginJetpackSetupHostingController(siteURL: testURL, connectionOnly: true, analytics: analytics, onStoreNavigation: {})

        // When
        _ = try XCTUnwrap(viewController.view)

        // Then
        XCTAssertNotNil(analyticsProvider.receivedEvents.first(where: { $0 == "login_jetpack_install_screen_viewed" }))
    }

    func test_it_tracks_login_jetpack_install_screen_dismissed_when_view_is_dismissed() throws {
        // Given
        let analyticsProvider = MockAnalyticsProvider()
        let analytics = WooAnalytics(analyticsProvider: analyticsProvider)
        let viewController = LoginJetpackSetupHostingController(siteURL: testURL, connectionOnly: true, analytics: analytics, onStoreNavigation: {})

        // When
        _ = try XCTUnwrap(viewController.view)
        let leftBarButtonItem = try XCTUnwrap(viewController.navigationItem.leftBarButtonItem)

        _ = leftBarButtonItem.target?.perform(leftBarButtonItem.action)
        // Then
        XCTAssertNotNil(analyticsProvider.receivedEvents.first(where: { $0 == "login_jetpack_install_screen_dismissed" }))
    }
}
