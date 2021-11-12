import Foundation
import UIKit

/// Represents all of the possible Order Date Ranges in enum form + start and end date in case of custom dates
///
struct OrderDateRangeFilter: Equatable {
    var filter: OrderDateRangeFilterEnum
    var startDate: Date?
    var endDate: Date?

    var computedStartDate: Date? {
        switch filter {
        case .today:
            return Date().startOfDay(timezone: TimeZone.siteTimezone)
        case .last2Days:
            return Calendar.current.date(byAdding: .day, value: -2, to: Date())?.startOfDay(timezone: TimeZone.siteTimezone)
        case .last7Days:
            return Calendar.current.date(byAdding: .day, value: -7, to: Date())?.startOfDay(timezone: TimeZone.siteTimezone)
        case .last30Days:
            return Calendar.current.date(byAdding: .day, value: -30, to: Date())?.startOfDay(timezone: TimeZone.siteTimezone)
        case .custom:
            return startDate?.startOfDay(timezone: TimeZone.siteTimezone)
        default:
            return nil
        }
    }

    var computedEndDate: Date? {
        switch filter {
        case .custom:
            return endDate?.endOfDay(timezone: TimeZone.siteTimezone)
        default:
            return nil
        }
    }
}

// MARK: - FilterType conformance
extension OrderDateRangeFilter: FilterType {
    /// Returns the localized text version of the Enum
    ///
    var description: String {
        switch filter {
        case .any:
            return NSLocalizedString("Any", comment: "Label for one of the filters in order date range")
        case .today:
            return NSLocalizedString("Today", comment: "Label for one of the filters in order date range")
        case .last2Days:
            return NSLocalizedString("Last 2 Days", comment: "Label for one of the filters in order date range")
        case .last7Days:
            return NSLocalizedString("Last 7 Days", comment: "Label for one of the filters in order date range")
        case .last30Days:
            return NSLocalizedString("Last 30 Days", comment: "Label for one of the filters in order date range")
        case .custom:
            return NSLocalizedString("Custom Range", comment: "Label for one of the filters in order date range")
        }
    }

    var isActive: Bool {
        return true
    }
}

/// Represents all of the possible Order Date Ranges in enum form
///
enum OrderDateRangeFilterEnum: Hashable, CaseIterable {
    case any
    case today
    case last2Days
    case last7Days
    case last30Days
    case custom
}

// MARK: - TableView utils
extension OrderDateRangeFilterEnum {
    var cellType: UITableViewCell.Type {
        switch self {
        case .any, .today, .last2Days, .last7Days, .last30Days:
            return BasicTableViewCell.self
        case .custom:
            return TitleAndValueTableViewCell.self
        }
    }

    var reuseIdentifier: String {
        return cellType.reuseIdentifier
    }
}
