import Yosemite
import Foundation
import Storage

struct PaymentsPluginsInfoProvider {
    let storageManager: StorageManagerType
    let siteID: Int64?

    init(
        storageManager: StorageManagerType = ServiceLocator.storageManager,
        siteID: Int64?
    ) {
        self.storageManager = storageManager
        self.siteID = siteID
    }

    func getWCPayPlugin() -> Yosemite.SystemPlugin? {
        guard let siteID = siteID else {
            return nil
        }
        return storageManager.viewStorage
            .loadSystemPlugin(siteID: siteID, name: CardPresentPaymentsPlugins.wcPay.pluginName)?
            .toReadOnly()
    }

    func getStripePlugin() -> Yosemite.SystemPlugin? {
        guard let siteID = siteID else {
            return nil
        }
        return storageManager.viewStorage
            .loadSystemPlugin(siteID: siteID, name: CardPresentPaymentsPlugins.stripe.pluginName)?
            .toReadOnly()
    }

    func bothPluginsInstalledAndActive(wcPay: Yosemite.SystemPlugin?, stripe: Yosemite.SystemPlugin?) -> Bool {
        guard let wcPay = wcPay, let stripe = stripe else {
            return false
        }

        return wcPay.active && stripe.active
    }

    func wcPayInstalledAndActive(wcPay: Yosemite.SystemPlugin?) -> Bool {
        // If the WCPay plugin is not installed, immediately return false
        guard let wcPay = wcPay else {
            return false
        }

        return wcPay.active
    }

    func stripeInstalledAndActive(stripe: Yosemite.SystemPlugin?) -> Bool {
        // If the Stripe plugin is not installed, immediately return false
        guard let stripe = stripe else {
            return false
        }

        return stripe.active
    }


    func isWCPayVersionSupported(plugin: Yosemite.SystemPlugin) -> Bool {
        VersionHelpers.isVersionSupported(version: plugin.version, minimumRequired: CardPresentPaymentsPlugins.wcPay.minimumSupportedPluginVersion)
    }

    func isStripeVersionSupported(plugin: Yosemite.SystemPlugin) -> Bool {
        VersionHelpers.isVersionSupported(version: plugin.version, minimumRequired: CardPresentPaymentsPlugins.stripe.minimumSupportedPluginVersion)
    }
}
