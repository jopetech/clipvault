import SwiftUI
import AppKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: ClipboardViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ClipboardEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<ClipboardEntry>

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: ClipboardViewModel(context: context))
        _entries = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \ClipboardEntry.date, ascending: false)],
            animation: .default)
    }

    var body: some View {
        Table(entries) {
            TableColumn("Preview") { entry in
                if let image = entry.previewImage {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                } else if entry.type == "text",
                          let text = String(data: entry.contentData, encoding: .utf8) {
                    Text(text).lineLimit(1)
                } else {
                    Image(nsImage: NSWorkspace.shared.icon(forFileType: entry.fileExtension))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
            TableColumn("Name") { entry in
                Text(entry.originalName)
            }
            TableColumn("Extension") { entry in
                Text(entry.fileExtension)
            }
            TableColumn("Date") { entry in
                Text(entry.date, style: .time)
            }
            TableColumn("Copy") { entry in
                Button("Copy") {
                    viewModel.copyToPasteboard(entry)
                }
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

#Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(context: PersistenceController.shared.container.viewContext)
    }
}
