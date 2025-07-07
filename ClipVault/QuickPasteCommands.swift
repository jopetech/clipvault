import SwiftUI

struct QuickPasteCommands: Commands {
    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandGroup(after: CommandGroupPlacement.pasteboard) {
            Button("Quick Paste") {
                openWindow(id: "QuickPaste")
            }
            .keyboardShortcut("v", modifiers: [.command, .option])
        }
    }
}
