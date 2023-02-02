import AutomatticTracks

/// Cache based implementation of `ABTestVariationProvider`
///
public struct CachedABTestVariationProvider: ABTestVariationProvider {

    private let cache: VariationCache

    public init(cache: VariationCache = VariationCache(userDefaults: .standard)) {
        self.cache = cache
    }

    public func variation(for abTest: ABTest) -> Variation {
        guard abTest.context == .loggedOut else {
            return abTest.variation ?? .control
        }

        if let cachedVariation = cache.variation(for: abTest) {
            return cachedVariation
        } else if let variation = abTest.variation {
            try? cache.assign(variation: variation, for: abTest)
            return variation
        } else {
            return .control
        }
    }
}
