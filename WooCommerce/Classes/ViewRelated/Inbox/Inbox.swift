import Combine
import SwiftUI
import Yosemite

/// Shows a list of inbox notes as shown in WooCommerce Admin in core.
struct Inbox: View {
    /// View model that drives the view.
    @ObservedObject private(set) var viewModel: InboxViewModel

    init(viewModel: InboxViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            switch viewModel.syncState {
            case .results:
                InfiniteScrollList(isLoading: viewModel.shouldShowBottomActivityIndicator,
                                   loadAction: viewModel.onLoadNextPageAction) {
                    ForEach(viewModel.noteRowViewModels) { rowViewModel in
                        if #available(iOS 15.0, *) {
                            // In order to show full-width separator, the default list separator is hidden and a `Divider` is shown inside the row.
                            InboxNoteRow(viewModel: rowViewModel)
                                .listRowSeparator(.hidden)
                        } else {
                            InboxNoteRow(viewModel: rowViewModel)
                        }
                    }
                }
            case .empty:
                // TODO: 5954 - update empty state
                EmptyState(title: Localization.emptyStateTitle,
                           description: Localization.emptyStateMessage,
                           image: .emptyProductsTabImage)
                    .frame(maxHeight: .infinity)
            case .syncingFirstPage:
                List {
                    ForEach(viewModel.placeholderRowViewModels) { rowViewModel in
                        InboxNoteRow(viewModel: rowViewModel)
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .background(Color(.listBackground).ignoresSafeArea())
        .navigationTitle(Localization.title)
        .onAppear {
            viewModel.onLoadTrigger.send()
        }
    }
}

private extension Inbox {
    enum Localization {
        static let title = NSLocalizedString("Inbox", comment: "Title for the screen that shows inbox notes.")
        static let emptyStateTitle = NSLocalizedString("Congrats, you’ve read everything!",
                                                         comment: "Title displayed if there are no inbox notes in the inbox screen.")
        static let emptyStateMessage = NSLocalizedString("Come back soon for more tips and insights on growing your store",
                                                         comment: "Message displayed if there are no inbox notes to display in the inbox screen.")
    }
}

#if DEBUG

/// Allows mocking for previewing `Inbox` view.
private final class PreviewInboxNotesStoresManager: DefaultStoresManager {
    private let inboxNotes: [InboxNote]

    init(inboxNotes: [InboxNote], sessionManager: SessionManager = SessionManager.standard) {
        self.inboxNotes = inboxNotes
        super.init(sessionManager: sessionManager)
    }

    // MARK: - Overridden Methods

    override func dispatch(_ action: Action) {
        if let action = action as? InboxNotesAction {
            onInboxNotesAction(action: action)
        } else {
            super.dispatch(action)
        }
    }

    private func onInboxNotesAction(action: InboxNotesAction) {
        switch action {
        case .loadAllInboxNotes(_, _, _, _, _, _, let completion):
            completion(.success(inboxNotes))
            return
        default:
            return
        }
    }
}

extension InboxNote {
    static func placeholder() -> InboxNote {
        .init(siteID: 255,
              id: 0,
              name: "",
              type: "",
              status: "",
              actions: [.init(id: 0, name: "", label: "Accept Apple Pay", status: "", url: "https://wordpress.com")],
              title: "Boost sales this holiday season with Apple Pay!",
              content: "",
              isRemoved: false,
              isRead: false,
              dateCreated: .init())
    }
}

struct Inbox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Placeholder state.
            Inbox(viewModel: .init(siteID: 122))
                .preferredColorScheme(.light)
            Inbox(viewModel: .init(siteID: 122))
                .preferredColorScheme(.dark)
            // Empty state.
            Inbox(viewModel: .init(siteID: 322,
                                   stores: PreviewInboxNotesStoresManager(inboxNotes: [])))
                .preferredColorScheme(.light)
            Inbox(viewModel: .init(siteID: 322,
                                   stores: PreviewInboxNotesStoresManager(inboxNotes: [])))
                .preferredColorScheme(.dark)
            // Results state.
            Inbox(viewModel: .init(siteID: 322,
                                   stores: PreviewInboxNotesStoresManager(inboxNotes: [.placeholder(), .placeholder()])))
                .preferredColorScheme(.light)
            Inbox(viewModel: .init(siteID: 322,
                                   stores: PreviewInboxNotesStoresManager(inboxNotes: [.placeholder(), .placeholder()])))
                .preferredColorScheme(.dark)
        }
    }
}

#endif