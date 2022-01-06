import ScreenObject
import XCTest
// import WooCommerce

public final class SingleOrderScreen: ScreenObject {

    // TODO: Remove force `try` once `ScreenObject` migration is completed
    let tabBar = try! TabNavComponent()
 //   private let ProductsSection: XCUIElement
 //   let ProductsSection = "single-product-cell"

    init(app: XCUIApplication = XCUIApplication()) throws {
        try super.init(
            expectedElementGetters: [{ $0.staticTexts["summary-table-view-cell-title-label"]} ],
               // { $0.cells["single-product-cell"] } ],
            app: app
        )
    }

    @discardableResult
    public func verifySingleOrder(order: OrderData) throws -> Self {
        app.assertTextVisibilityCount(textToFind: order.status, expectedCount: 1)
        app.assertTextVisibilityCount(textToFind: order.billing.first_name, expectedCount: 2) // the first name "Mira" appears twice
        try app.verifyChildElementOnParentCell(parent: "single-product-cell", child: "Mira")
        app.assertTextVisibilityCount(textToFind: order.total, expectedCount: 1)
        XCTAssertTrue(app.textViews[order.line_items[0].name].isFullyVisibleOnScreen(), "First product name is not visible on screen!")

// app.tables.cells.element(boundBy: index)  or orders[0]

//        app.elementIsFullyVisibleOnScreen(element: "single-product-cell")
        return self
        // we could also use accessibiltyIDs for this, possibly via elementIsFullyVisibleOnScreen
    }

    @discardableResult
    public func goBackToOrdersScreen() throws -> OrdersScreen {
        pop()
        return try OrdersScreen()
    }
}
