import SwiftUI
import AppKit

struct QuickPasteView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var viewModel: ClipboardViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClipboardEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<ClipboardEntry>

    init() {}

    var body: some View {
        List(entries, id: \.self) { entry in
            HStack {
                if let image = entry.previewImage {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                } else if entry.type == "text",
                          let text = String(data: entry.contentData, encoding: .utf8) {
                    Text(text).lineLimit(1)
                } else {
                    Image(nsImage: NSWorkspace.shared.icon(forFileType: entry.fileExtension))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                Text(entry.originalName)
            }
            .onTapGesture {
                viewModel.copyToPasteboard(entry)
                NSApp.keyWindow?.close()
            }
        }
        .frame(width: 300, height: 250)
    }
}

#Preview
struct QuickPasteView_Previews: PreviewProvider {
    static var previews: some View {
        QuickPasteView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .environmentObject(ClipboardViewModel(context: PersistenceController.shared.container.viewContext))
    }
}
