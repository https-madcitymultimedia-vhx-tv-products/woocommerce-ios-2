import Foundation
import Combine

class NewOrderCustomerNoteViewModel: EditCustomerNoteViewModelProtocol {
    /// Store for the edited content
    ///
    @Published var newNote: String

    /// Defines the navigation right button state
    ///
    @Published private(set) var navigationTrailingItem: EditCustomerNoteNavigationItem = .done(enabled: false)

    /// Not used.
    ///
    @Published var presentNotice: EditCustomerNoteNotice? = nil

    /// Not used.
    ///
    var presentNoticePublisher: Published<EditCustomerNoteNotice?>.Publisher {
        $presentNotice
    }

    /// Commit the original note.
    ///
    func updateNote(onFinish: @escaping (Bool) -> Void) {
        originalNote = newNote
        onFinish(true)
    }

    /// Revert to original content.
    ///
    func userDidCancelFlow() {
        newNote = originalNote
    }

    /// Stores the original note content.
    ///
    @Published private var originalNote: String

    init(originalNote: String = "") {
        self.originalNote = originalNote
        self.newNote = originalNote
        bindNoteChanges()
    }

    /// Assigns the correct navigation trailing item as the new note content changes.
    ///
    private func bindNoteChanges() {
        Publishers.CombineLatest($newNote, $originalNote)
            .map { editedContent, originalNote -> EditCustomerNoteNavigationItem in
                .done(enabled: editedContent != originalNote)
            }
            .assign(to: &$navigationTrailingItem)
    }
}