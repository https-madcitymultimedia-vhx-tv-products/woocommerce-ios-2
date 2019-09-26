import UIKit

/// An interface for search UI associated with a generic model and cell view model.
protocol SearchCommand {
    associatedtype Model
    associatedtype CellViewModel

    /// The placeholder of the search bar.
    var searchBarPlaceholder: String { get }

    /// Displayed when there are no search results.
    var emptyStateText: String { get }

    /// Creates a view model for the search result cell.
    ///
    /// - Parameter model: search result model.
    /// - Returns: a view model based on the search result model.
    func createCellViewModel(model: Model) -> CellViewModel

    /// Synchronizes the models matching a given keyword.
    func synchronizeModels(siteID: Int,
                           keyword: String,
                           pageNumber: Int,
                           pageSize: Int,
                           onCompletion: ((Bool) -> Void)?)

    /// Called when user selects a search result.
    ///
    /// - Parameters:
    ///   - model: search result model.
    ///   - viewController: view controller where the user selects the search result.
    func didSelectSearchResult(model: Model, from viewController: UIViewController)
}
