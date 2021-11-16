import Foundation
import Storage


// Storage.Site: ReadOnlyConvertible Conformance.
//
extension Storage.Site: ReadOnlyConvertible {

    /// Updates the Storage.Site with the a ReadOnly.
    ///
    public func update(with site: Yosemite.Site) {
        siteID = site.siteID
        name = site.name
        tagline = site.description
        url = site.url
//        plan = site.plan // We're not assigning the plan here because it's not sent on the intial API request.
        // TODO: 5364 - update `isJetpackThePluginInstalled`
        // TODO: 5364 - update `isJetpackConnected`
        isWooCommerceActive = NSNumber(booleanLiteral: site.isWooCommerceActive)
        isWordPressStore = NSNumber(booleanLiteral: site.isWordPressStore)
        timezone = site.timezone
        gmtOffset = site.gmtOffset
    }

    /// Returns a ReadOnly version of the receiver.
    ///
    public func toReadOnly() -> Yosemite.Site {
        return Site(siteID: siteID,
                    name: name ?? "",
                    description: tagline ?? "",
                    url: url ?? "",
                    plan: plan ?? "",
                    isJetpackThePluginInstalled: true, // TODO: 5364 - persist in storage
                    isJetpackConnected: true, // TODO: 5364 - persist in storage
                    isWooCommerceActive: isWooCommerceActive?.boolValue ?? false,
                    isWordPressStore: isWordPressStore?.boolValue ?? false,
                    timezone: timezone ?? "",
                    gmtOffset: gmtOffset)
    }
}
