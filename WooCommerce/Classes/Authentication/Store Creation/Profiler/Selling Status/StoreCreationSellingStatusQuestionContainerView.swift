import SwiftUI

/// Hosting controller that wraps the `StoreCreationSellingStatusQuestionContainerView`.
final class StoreCreationSellingStatusQuestionHostingController: UIHostingController<StoreCreationSellingStatusQuestionContainerView> {
    init(storeName: String, onContinue: @escaping () -> Void, onSkip: @escaping () -> Void) {
        super.init(rootView: StoreCreationSellingStatusQuestionContainerView(storeName: storeName, onContinue: onContinue, onSkip: onSkip))
    }

    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTransparentNavigationBar()
    }
}

/// Displays the selling status question initially. If the user chooses the "I'm already selling online" option, the selling
/// platforms question is shown.
struct StoreCreationSellingStatusQuestionContainerView: View {
    @StateObject private var viewModel: StoreCreationSellingStatusQuestionViewModel
    private let storeName: String
    private let onContinue: () -> Void
    private let onSkip: () -> Void

    init(storeName: String, onContinue: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: StoreCreationSellingStatusQuestionViewModel(storeName: storeName, onContinue: onContinue, onSkip: onSkip))
        self.storeName = storeName
        self.onContinue = onContinue
        self.onSkip = onSkip
    }

    var body: some View {
        if viewModel.isAlreadySellingOnline {
            StoreCreationSellingPlatformsQuestionView(storeName: storeName, onContinue: onContinue, onSkip: onSkip)
        } else {
            StoreCreationSellingStatusQuestionView(viewModel: viewModel)
        }
    }
}

struct StoreCreationSellingStatusQuestionContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StoreCreationSellingStatusQuestionContainerView(storeName: "New Year Store", onContinue: {}, onSkip: {})
        }
    }
}
