import SwiftUI

@main
struct ClipVaultApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var viewModel: ClipboardViewModel

    init() {
        let context = persistenceController.container.viewContext
        _viewModel = StateObject(wrappedValue: ClipboardViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
        WindowGroup("Quick Paste", id: "QuickPaste") {
            QuickPasteView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
        .defaultSize(width: 300, height: 250)
        .windowStyle(.hiddenTitleBar)
    }

    var commands: some Commands {
        QuickPasteCommands()
    }
}
